# Homebrew Utilities

Custom [Homebrew](https://brew.sh) formulas and casks for tools that need patches, custom builds, or release tracking unavailable in homebrew-core.

## Usage

```bash
brew tap ylluminate/utilities
```

## Formulas

| Formula | Description | Why not homebrew-core? |
|---------|-------------|----------------------|
| [meat](Formula/meat.rb) | Abridge a code diff into a "reading diff" using an LLM | Not packaged anywhere; upstream ships only `go install` |
| [plocate](Formula/plocate.rb) | Fast file search using posting lists and trigram indexing | macOS port not upstream |
| [proxychains-ng](Formula/proxychains-ng.rb) | SOCKS5/HTTP hook preloader with arm64e support | homebrew-core builds arm64 only; systems with `-arm64e_preview_abi` need arm64e slices |

### meat

```bash
brew install --HEAD ylluminate/utilities/meat
export OPENAI_API_KEY=...        # or ANTHROPIC_API_KEY
meat                             # abridge the latest commit
git diff main...HEAD | meat      # or a diff on stdin
```

[meat](https://github.com/boldsoftware/meat) uses a model to reduce a diff to the
parts a reviewer actually needs to read. Upstream documents `go install
meat.dev/cmd/meat@latest` as the only install path, which leaves the binary
outside Homebrew's management; this formula brings it under `brew` instead.

Upstream publishes no tags and no releases — `main` is the only ref — so the
formula is HEAD-only and tracks that branch:

```bash
brew upgrade --fetch-HEAD ylluminate/utilities/meat
```

`--fetch-HEAD` is required: without it Homebrew only re-checks a HEAD
installation when a stable release appears, and meat has none. Set
`fetch_head = true` under `[brew]` in `topgrade.toml` to get this automatically.

The build has no external Go dependencies (there is no `go.sum`), so it compiles
offline in a couple of seconds.

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

## Evaluated and not adopted

This tap is for tools that need patches, custom builds, or release tracking unavailable in
homebrew-core. Things that merely lost their core formula do **not** qualify if a maintained
equivalent exists. Recorded so the question is not re-litigated:

| Dropped from core | Why not adopted here | Use instead |
|---|---|---|
| neofetch 7.1.0 (`repo_archived`) | canonical successor is maintained and in core | `fastfetch` |
| pfetch 0.6.0 (`repo_archived`) | maintained Rust rewrite, same command name | `pfetch-rs` |
| jam 2.6.1 (`unmaintained`) | `argyll-cms` already ships the byte-identical Jam 2.6.1, and `/opt/homebrew/bin/jam` already pointed at it | `argyll-cms` (or `bjam` for Boost.Build) |

Adopt only when all three hold: the tool is actually used; no maintained formula provides the same
capability, including under another name or bundled inside another formula; and upstream still
exists or we are prepared to carry the source.

A deprecated formula that still installs is not an orphan yet. The real signal is `brew formula
<name>` resolving to `$(brew --prefix)/opt/<name>/.brew/<name>.rb` instead of somewhere under
`Library/Taps/` — at that point only the keg-local copy is left and it can never update again.

## Casks

| Cask | Description |
|------|-------------|
| [recordly](Casks/recordly.rb) | Screen and audio recorder — always tracks the latest upstream release |
| [font-fixedsys-excelsior](Casks/font-fixedsys-excelsior.rb) | Fixedsys Excelsior font with programming ligatures — not carried by homebrew-cask |
| [font-fixedsys-excelsior-alt](Casks/font-fixedsys-excelsior-alt.rb) | Same font, alternate ligatures (`<=` instead of `=<`) — mutually exclusive with the above |
| [webtorrent-arm64](Casks/webtorrent-arm64.rb) | WebTorrent Desktop built native for Apple Silicon — homebrew-cask ships x86_64 only |

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

The `-alt` cask installs the alternate build (`FSEX302-alt.ttf`), which ligates `<=` into ≤ (the common programmer form) instead of `=<`. Both share the internal family name "Fixedsys Excelsior", so only one can be installed at a time (`conflicts_with` enforces this). To switch:

```bash
brew uninstall --cask font-fixedsys-excelsior
brew install --cask ylluminate/utilities/font-fixedsys-excelsior-alt
```

### webtorrent-arm64

```bash
brew uninstall --cask webtorrent   # if the homebrew-cask build is installed
brew install --cask ylluminate/utilities/webtorrent-arm64
```

The homebrew-cask [`webtorrent`](https://github.com/Homebrew/homebrew-cask/blob/HEAD/Casks/w/webtorrent.rb) cask ships an x86_64-only build and ends with `requires_rosetta`. This cask installs [gingergeek8192/webtorrent-desktop](https://github.com/gingergeek8192/webtorrent-desktop) instead — a packaging-only fork of [webtorrent/webtorrent-desktop](https://github.com/webtorrent/webtorrent-desktop) whose release is built for `arm64`, so it runs natively on Apple Silicon with no translation.

Verified in the shipped bundle rather than taken from the README: both `WebTorrent.app/Contents/MacOS/WebTorrent` and the embedded Electron Framework report `arm64` under `lipo -archs`, `CFBundleShortVersionString` is `0.24.0`, and `LSMinimumSystemVersion` is `12.0` (hence `depends_on macos: :monterey`).

Two things to know before installing:

- **The build is unofficial and ad-hoc signed** — no Developer ID, no notarization, `TeamIdentifier=not set`. Where Gatekeeper is enabled macOS blocks the first launch; approve it under System Settings → Privacy & Security, or add `--no-quarantine`. The binary cannot be verified against the fork's source.
- **It carries a newer Electron than the official build** — 39.x versus 27.x in the official 0.24.0 — so its bundled Chromium is substantially more current.

The fork's single release is tagged `v0.25.0-arm64` while the app and its dmg are `0.24.0`, so the cask carries both: `version.csv.first` is the app version and `version.csv.second` is the release tag. `brew livecheck` is wired to read a newer tag and dmg pair out of the releases API if one appears.

Because the fork changes only packaging (6 commits touching `package.json`, lockfiles and `bin/package.js` — no application source), building the same artifact from a fork we control is a straightforward way to remove the provenance gap.
