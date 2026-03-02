# homebrew-utilities

Homebrew tap for [ylluminate](https://github.com/ylluminate) utilities.

## Install

```bash
brew tap ylluminate/utilities
```

## Formulas

| Formula | Description |
|---------|-------------|
| [plocate](https://github.com/ylluminate/plocate-macos) | Fast file search for macOS — locate files instantly from the terminal |

### plocate

```bash
brew install --HEAD ylluminate/utilities/plocate
```

After install, build the initial database:

```bash
sudo updatedb
```

See the [plocate-macos README](https://github.com/ylluminate/plocate-macos) for configuration and usage.
