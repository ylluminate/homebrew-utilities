# Homebrew Utilities

Custom [Homebrew](https://brew.sh) formulas and casks for tools that need patches, custom builds, or release tracking unavailable in homebrew-core.

## Usage

```bash
brew tap ylluminate/utilities
```

## Formulas

| Formula | Description | Why not homebrew-core? |
|---------|-------------|----------------------|
| [plocate](Formula/plocate.rb) | Fast file search using posting lists and trigram indexing | macOS port not upstream |
| [proxychains-ng](Formula/proxychains-ng.rb) | SOCKS5/HTTP hook preloader with arm64e support | homebrew-core builds arm64 only; systems with `-arm64e_preview_abi` need arm64e slices |

### plocate

```bash
brew install --HEAD ylluminate/utilities/plocate
sudo updatedb --require-visibility no
locate <pattern>
```

See [plocate-macos](https://github.com/ylluminate/plocate-macos) for configuration.

### proxychains-ng

Builds [proxychains-ng](https://github.com/rofl0r/proxychains-ng) from latest master with universal arm64+arm64e architecture. Required on Apple Silicon Macs with `-arm64e_preview_abi` in nvram boot-args, where the homebrew-core bottle fails with `incompatible architecture (have 'arm64', need 'arm64e')`.

```bash
brew install --HEAD ylluminate/utilities/proxychains-ng
proxychains4 curl http://ifconfig.me
proxychains4 topgrade
```

Upgrade when upstream has new commits:

```bash
brew upgrade --fetch-HEAD ylluminate/utilities/proxychains-ng
```

## Casks

| Cask | Description |
|------|-------------|
| [recordly](Casks/recordly.rb) | Screen and audio recorder — always tracks the latest upstream release |
| [font-fixedsys-excelsior](Casks/font-fixedsys-excelsior.rb) | Fixedsys Excelsior font with programming ligatures — not carried by homebrew-cask |

### recordly

```bash
brew install --cask ylluminate/utilities/recordly
```

Pulls the most recent [Recordly](https://github.com/webadderall/Recordly) release on install, independent of architecture (arm64 or x86_64). The app's built-in updater handles ongoing updates, so the cask never needs version bumps.

### font-fixedsys-excelsior

```bash
brew install --cask ylluminate/utilities/font-fixedsys-excelsior
```

Installs [Fixedsys Excelsior](https://github.com/kika/fixedsys) (`FSEX302.ttf`) to `~/Library/Fonts` — a revival of the classic Fixedsys with programming ligatures. Not available in homebrew-cask. After installing, select "Fixedsys Excelsior" in your terminal or editor font settings.
