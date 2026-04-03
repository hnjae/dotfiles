{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "tinted-builder-rust";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-builder-rust";
    rev = "v${version}";
    hash = "sha256-gdvgdiFVp4DLVjyuDGAAVkhEAeQ8c33qRjCq1F8IfE8=";
  };

  cargoHash = "sha256-mpgH3IwmCQo1FrlFh8ofSjEQfJkClWtlWTqax55255s=";

  doCheck = false;

  meta = {
    description = "A base16 and base24 builder written in Rust, focused on convenience for template maintainers";
    homepage = "https://github.com/tinted-theming/tinted-builder-rust";
    changelog = "https://github.com/tinted-theming/tinted-builder-rust/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "tinted-builder-rust";
    platforms = lib.platforms.all;
  };
}
