#!/usr/bin/env python3
"""Install the agent skills pinned in skills.toml and expose some to Claude Code.

`~/.agents/skills/` is the installed pool: every skill in it is visible to pi,
which scans the directory by itself. `~/.claude/skills/` is a subset chosen by
`~/.agents/claude-skills.txt`, because Claude Code reads only that directory and
would otherwise pick up the account skills in its own `synced/` bucket.

Each fetch is a `git clone` of one upstream repository at the commit recorded in
the manifest, done by the `skills` CLI. Only the selected skill directories are
copied into the pool.
"""

from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
import tomllib
from dataclasses import dataclass
from pathlib import Path

CLI = "skills@1.8"
BUNX = "bunx"
STORE = Path.home() / ".agents/skills"
MANIFEST = Path.home() / ".agents/skills.toml"
EXPOSED = Path.home() / ".agents/claude-skills.txt"
CLAUDE = Path.home() / ".claude/skills"
AUTHORED = Path(__file__).resolve().parents[1] / "home+.agents+skills"
NAME_RE = re.compile(r"^[a-zA-Z0-9][a-zA-Z0-9._-]*$")
REPO_RE = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")
COMMIT_RE = re.compile(r"^[0-9a-f]{7,64}$")
HEADING = "[[source]]"


@dataclass(frozen=True)
class Skill:
    """One skill directory to install from a repository."""

    name: str
    path: str | None = None


@dataclass(frozen=True)
class Source:
    """One upstream repository pinned at one commit."""

    repo: str
    commit: str
    skills: tuple[Skill, ...]
    path: str | None = None
    ref: str | None = None


def fail(message: str) -> None:
    """Print an error and stop."""
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def check_path(repo: str, path: str) -> None:
    """Reject a subpath that could escape the repository."""
    if path.startswith("/") or ".." in Path(path).parts:
        fail(f"bad path for {repo}: {path!r}")


def read_manifest() -> list[Source]:
    """Parse and validate skills.toml."""
    if not MANIFEST.is_file():
        fail(f"no manifest at {MANIFEST}")
    raw = tomllib.loads(MANIFEST.read_text(encoding="utf-8"))
    sources = []
    for block in raw.get("source", []):
        repo = str(block.get("repo", ""))
        if not REPO_RE.match(repo):
            fail(f"bad repo {repo!r}; expected owner/name")
        commit = str(block.get("hash", ""))
        if not COMMIT_RE.match(commit):
            fail(f"bad hash for {repo}: {commit!r}")
        path = block.get("path")
        if path is not None:
            check_path(repo, str(path))
            path = str(path)
        skills = []
        for entry in block.get("skills", []):
            if isinstance(entry, str):
                skills.append(Skill(entry))
                continue
            inner = entry.get("path")
            if inner is not None:
                check_path(repo, str(inner))
            skills.append(Skill(str(entry["name"]), inner))
        ref = block.get("ref")
        sources.append(
            Source(
                repo=repo,
                commit=commit,
                skills=tuple(skills),
                path=path,
                ref=None if ref is None else str(ref),
            )
        )
    validate(sources)
    return sources


def validate(sources: list[Source]) -> None:
    """Reject duplicate or reserved skill names."""
    seen: dict[str, str] = {}
    for source in sources:
        for skill in source.skills:
            if not NAME_RE.match(skill.name):
                fail(f"bad skill name {skill.name!r} in {source.repo}")
            owner = seen.get(skill.name)
            if owner is not None:
                fail(
                    f"skill {skill.name!r} is claimed by "
                    f"{owner} and {source.repo}",
                )
            seen[skill.name] = source.repo
    if not AUTHORED.is_dir():
        return
    authored = {entry.name for entry in AUTHORED.iterdir()}
    clash = sorted(authored & seen.keys())
    if clash:
        fail("skill name collides with an authored skill: " + ", ".join(clash))


def groups(source: Source) -> dict[str | None, list[str]]:
    """Group the skills of a source by the subpath they live under."""
    grouped: dict[str | None, list[str]] = {}
    for skill in source.skills:
        key = skill.path if skill.path is not None else source.path
        grouped.setdefault(key, []).append(skill.name)
    return grouped


def source_url(source: Source, path: str | None) -> str:
    """Build the CLI source argument for one subpath of a repository."""
    if path:
        return f"https://github.com/{source.repo}/tree/{source.commit}/{path}"
    return f"{source.repo}#{source.commit}"


def installed(name: str) -> bool:
    """Return whether the pool holds a working copy of the skill."""
    return (STORE / name / "SKILL.md").is_file()


def install(
    source: Source,
    path: str | None,
    names: list[str],
    *,
    dry_run: bool,
) -> bool:
    """Fetch one source group and copy the named skills into the pool."""
    where = source.repo + (f"/{path}" if path else "")
    if dry_run:
        print(f"would install {', '.join(names)} from {where}")
        return True
    command = [
        BUNX,
        CLI,
        "add",
        source_url(source, path),
        "-s",
        *names,
        "-g",
        "-a",
        "universal",
        "-y",
    ]
    print(f"installing {', '.join(names)} from {where}@{source.commit[:10]}")
    if subprocess.run(command, check=False).returncode != 0:
        print(f"failed: {where}", file=sys.stderr)
        return False
    return True


def prune(desired: set[str], *, dry_run: bool) -> list[str]:
    """Remove pool directories the manifest does not list.

    Symlinks are authored skills and belong to dotbot, never to this script.
    """
    removed = []
    for entry in sorted(STORE.iterdir()):
        if entry.name in desired or entry.is_symlink() or not entry.is_dir():
            continue
        removed.append(entry.name)
        if not dry_run:
            shutil.rmtree(entry)
    return removed


def read_exposure() -> list[str]:
    """Read the Claude exposure list."""
    if not EXPOSED.is_file():
        fail(f"no exposure list at {EXPOSED}")
    names = []
    for line in EXPOSED.read_text(encoding="utf-8").splitlines():
        entry = line.strip()
        if entry and not entry.startswith("#"):
            names.append(entry)
    return names


def sync_exposure() -> None:
    """Make ~/.claude/skills hold exactly the exposed skills."""
    wanted = read_exposure()
    CLAUDE.mkdir(parents=True, exist_ok=True)
    for name in wanted:
        if not installed(name):
            print(f"skip {name}: not in the pool", file=sys.stderr)
            continue
        target = CLAUDE / name
        if target.is_symlink():
            target.unlink()
        elif target.exists():
            continue
        target.symlink_to(STORE / name)
    for entry in sorted(CLAUDE.iterdir()):
        if entry.is_symlink() and entry.name not in wanted:
            entry.unlink()


def restore(args: argparse.Namespace) -> int:
    """Install what the manifest lists, prune the rest, then sync exposure."""
    sources = read_manifest()
    if args.repo:
        unknown = sorted(set(args.repo) - {source.repo for source in sources})
        if unknown:
            fail("not in the manifest: " + ", ".join(unknown))
        sources = [source for source in sources if source.repo in args.repo]

    failed = 0
    for source in sources:
        for path, names in groups(source).items():
            todo = (
                names if args.force else [n for n in names if not installed(n)]
            )
            if todo and not install(source, path, todo, dry_run=args.dry_run):
                failed += 1

    listed = {skill.name for source in sources for skill in source.skills}
    if not failed and not args.repo:
        removed = prune(listed, dry_run=args.dry_run)
        if removed:
            verb = "would remove" if args.dry_run else "removed"
            print(f"{verb} {len(removed)} unlisted: {' '.join(removed)}")
    if not args.dry_run:
        sync_exposure()
    return 1 if failed else 0


def resolve_commit(repo: str, ref: str) -> str:
    """Resolve a ref to a commit through the remote."""
    url = f"https://github.com/{repo}.git"
    for candidate in (ref, f"refs/tags/{ref}"):
        result = subprocess.run(
            ["git", "ls-remote", url, candidate],
            capture_output=True,
            text=True,
            check=False,
        )
        rows = [
            line.split("\t") for line in result.stdout.splitlines() if line
        ]
        peeled = [sha for sha, name in rows if name.endswith("^{}")]
        if peeled:
            return peeled[0]
        if rows:
            return rows[0][0]
    fail(f"cannot resolve {ref} in {url}")
    return ""


def block_text(source: Source) -> str:
    """Render one manifest block."""
    lines = [HEADING, f'repo = "{source.repo}"', f'hash = "{source.commit}"']
    if source.ref:
        lines.append(f'ref = "{source.ref}"')
    if source.path:
        lines.append(f'path = "{source.path}"')
    names = [skill.name for skill in source.skills]
    if len(names) == 1:
        lines.append(f'skills = ["{names[0]}"]')
    else:
        lines.append("skills = [")
        lines.extend(f'  "{name}",' for name in names)
        lines.append("]")
    return "\n".join(lines)


def split_blocks(text: str) -> tuple[str, list[str]]:
    """Split the manifest into its preamble and raw blocks."""
    parts = text.split(HEADING)
    preamble = parts[0].rstrip("\n")
    return preamble, [HEADING + part.rstrip("\n") for part in parts[1:]]


def block_key(text: str) -> tuple[str, str]:
    """Sort key of a raw block: repository, then subpath."""
    repo = re.search(r'^repo = "(.*)"$', text, re.MULTILINE)
    path = re.search(r'^path = "(.*)"$', text, re.MULTILINE)
    return (repo.group(1) if repo else "", path.group(1) if path else "")


def write_manifest(preamble: str, blocks: list[str]) -> None:
    """Rewrite the manifest from its parts."""
    body = "\n\n".join(blocks)
    MANIFEST.write_text(f"{preamble}\n\n{body}\n", encoding="utf-8")


def add(args: argparse.Namespace) -> int:
    """Install skills from a repository and append them to the manifest."""
    sources = read_manifest()
    existing = {
        skill.name
        for source in sources
        if source.repo == args.repo
        for skill in source.skills
    }
    clash = sorted(existing & set(args.skill))
    if clash:
        fail(f"{args.repo} already lists: {', '.join(clash)}")
    source = Source(
        repo=args.repo,
        commit=resolve_commit(args.repo, args.ref or "HEAD"),
        skills=tuple(Skill(name) for name in args.skill),
        path=args.path,
        ref=args.ref,
    )
    if args.dry_run:
        print(block_text(source))
        return 0
    if not install(source, args.path, args.skill, dry_run=False):
        return 1
    preamble, blocks = split_blocks(MANIFEST.read_text(encoding="utf-8"))
    blocks.append(block_text(source))
    blocks.sort(key=block_key)
    write_manifest(preamble, blocks)
    read_manifest()
    print(f"recorded {', '.join(args.skill)} in {MANIFEST}")
    return 0


def update(args: argparse.Namespace) -> int:
    """Re-resolve the pinned commit of every block, or of the named ones."""
    preamble, blocks = split_blocks(MANIFEST.read_text(encoding="utf-8"))
    changed = 0
    for index, text in enumerate(blocks):
        repo, _ = block_key(text)
        if args.repo and repo not in args.repo:
            continue
        ref = re.search(r'^ref = "(.*)"$', text, re.MULTILINE)
        commit = resolve_commit(repo, ref.group(1) if ref else "HEAD")
        current = re.search(r'^hash = "(.*)"$', text, re.MULTILINE)
        if current is None:
            fail(f"block without hash: {repo}")
        if current.group(1) == commit:
            continue
        changed += 1
        print(f"{repo}: {current.group(1)[:10]} -> {commit[:10]}")
        blocks[index] = text.replace(current.group(0), f'hash = "{commit}"')
    if args.dry_run:
        print(f"{changed} block(s) would change")
        return 0
    if changed:
        write_manifest(preamble, blocks)
        read_manifest()
    print(f"{changed} block(s) updated")
    return 0


def show_pool(_: argparse.Namespace) -> int:
    """List pool skills that are not exposed to Claude Code."""
    sources = read_manifest()
    exposed = set(read_exposure())
    owner = {
        skill.name: source.repo
        for source in sources
        for skill in source.skills
    }
    hidden: dict[str, list[str]] = {}
    for name, repo in sorted(owner.items()):
        if name not in exposed:
            hidden.setdefault(repo, []).append(name)
    if not hidden:
        print("every listed skill is exposed")
    for repo, names in sorted(hidden.items()):
        print(f"{repo}: {' '.join(names)}")
    listed = set(owner)
    unlisted = sorted(
        entry.name
        for entry in STORE.iterdir()
        if entry.is_dir()
        and not entry.is_symlink()
        and entry.name not in listed
    )
    if unlisted:
        print(f"installed but not in the manifest: {' '.join(unlisted)}")
    return 0


def verify(_: argparse.Namespace) -> int:
    """Check that manifest, pool, and exposure agree."""
    sources = read_manifest()
    listed = {skill.name for source in sources for skill in source.skills}
    problems = [
        f"missing from the pool: {name}"
        for name in sorted(listed)
        if not installed(name)
    ]
    problems += [
        f"in the pool but not in the manifest: {entry.name}"
        for entry in sorted(STORE.iterdir())
        if entry.is_dir()
        and not entry.is_symlink()
        and entry.name not in listed
    ]
    problems += [
        f"exposed but not in the pool: {name}"
        for name in read_exposure()
        if not installed(name)
    ]
    for problem in problems:
        print(problem)
    print(
        f"{len(sources)} sources, {len(listed)} skills, {len(problems)} problems"
    )
    return 1 if problems else 0


def do_sync(_: argparse.Namespace) -> int:
    """Apply the exposure list."""
    sync_exposure()
    return 0


def build_parser() -> argparse.ArgumentParser:
    """Describe the command line."""
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub = parser.add_subparsers(dest="command", required=True)

    restore_parser = sub.add_parser("restore", help="install the manifest")
    restore_parser.add_argument("repo", nargs="*", help="limit to these repos")
    restore_parser.add_argument("--force", action="store_true", help="refetch")
    restore_parser.add_argument("--dry-run", action="store_true")
    restore_parser.set_defaults(func=restore)

    sync_parser = sub.add_parser("sync", help="apply the Claude exposure list")
    sync_parser.set_defaults(func=do_sync)

    add_parser = sub.add_parser("add", help="install and record a skill")
    add_parser.add_argument("repo")
    add_parser.add_argument("-s", "--skill", action="append", required=True)
    add_parser.add_argument("--path", help="subdirectory holding the skills")
    add_parser.add_argument(
        "--ref", help="branch or tag to resolve (default HEAD)"
    )
    add_parser.add_argument("--dry-run", action="store_true")
    add_parser.set_defaults(func=add)

    update_parser = sub.add_parser("update", help="re-resolve pinned commits")
    update_parser.add_argument("repo", nargs="*", help="limit to these repos")
    update_parser.add_argument("--dry-run", action="store_true")
    update_parser.set_defaults(func=update)

    pool_parser = sub.add_parser("pool", help="list pool skills not exposed")
    pool_parser.set_defaults(func=show_pool)

    verify_parser = sub.add_parser(
        "verify", help="check manifest, pool, exposure"
    )
    verify_parser.set_defaults(func=verify)
    return parser


def main() -> int:
    """Run the requested command, restoring by default."""
    argv = sys.argv[1:]
    if not argv or argv[0].startswith("-"):
        argv = ["restore", *argv]
    args = build_parser().parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
