# Homebrew Utilities

Custom [Homebrew](https://brew.sh) formulas for tools that need patches or builds unavailable in homebrew-core.

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
