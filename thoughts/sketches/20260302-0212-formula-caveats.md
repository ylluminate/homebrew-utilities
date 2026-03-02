# Sketch: Improve formula caveats with --require-visibility no

COVERS:
- Formula/plocate.rb (caveats only)

## Current State
```mermaid
flowchart TD
    Install[brew install plocate] --> Caveats[Prints caveats]
    Caveats --> Run[sudo updatedb]
    Run -->|missing group| Fail[May fail without _plocate group]
```

## What I'm Changing
Add `--require-visibility no` to caveats so the simple path works without group setup.

## What Must NOT Break
- Formula still installs
- brew test still passes

## How I'll Verify It Works
- [ ] Read caveats output after change
