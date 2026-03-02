# Sketch: Add locate -> plocate symlink in formula

COVERS:
- Formula/plocate.rb

## Current State
```mermaid
flowchart TD
    User["User types 'locate'"] --> Which{Which binary?}
    Which -->|gnubin in PATH| GLocate["/opt/homebrew/opt/findutils/libexec/gnubin/locate → glocate"]
    Which -->|gnubin NOT in PATH| NotFound["command not found (no /opt/homebrew/bin/locate)"]
    User2["User types 'plocate'"] --> PLocate["/opt/homebrew/bin/plocate"]
```

## After Change
```mermaid
flowchart TD
    User["User types 'locate'"] --> Which{Which binary?}
    Which -->|gnubin in PATH| GLocate["gnubin/locate → glocate (gnubin is later in PATH)"]
    Which -->|gnubin NOT in PATH| OurLocate["/opt/homebrew/bin/locate → plocate ✓"]
    Which -->|no findutils| OurLocate
    User2["User types 'plocate'"] --> PLocate["/opt/homebrew/bin/plocate"]
```

## What I'm Changing
Adding `bin.install_symlink "plocate" => "locate"` to put a locate symlink in /opt/homebrew/bin/.
No conflict: findutils only puts locate in libexec/gnubin/ (opt-in), not in bin/.

## What Must NOT Break
- plocate binary still works
- No conflict with findutils package
- brew install still succeeds

## How I'll Verify It Works
- [ ] brew reinstall succeeds
- [ ] which locate shows /opt/homebrew/bin/locate
- [ ] locate --version shows plocate
