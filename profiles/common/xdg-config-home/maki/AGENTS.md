# Agent Guidelines

## Investigation

- When attempts keep failing for the same reason, stop and name the assumption that may be wrong.
- Cap retries of the same probe at three tries. If all three fail, report the conclusion and the evidence, and ask before trying a fourth variation.
- Vary one input per try and record the observed result. If two tries return the same result, the variable under test is not the cause; stop varying it.
- Before calling an external tool's behavior a bug, check its official documentation and say that you did. An undocumented behavior you have not looked up is not evidence of a bug.
- A non-deterministic result means your measurement is uncontrolled, not that the tool is random. Fix every input, change one, and re-measure.
- When a question is answered, say so and name the next action instead of continuing to gather supporting evidence.

## Reporting

- Report when a phase ends: what is now known, what is still open, and the single next action.
- Ask before moving from investigation into implementation when the user asked only for a plan or a survey.
