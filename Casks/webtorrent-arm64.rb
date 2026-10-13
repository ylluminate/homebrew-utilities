cask "webtorrent-arm64" do
  # The app's own CFBundleShortVersionString is 0.24.0 and the dmg is named for
  # that, but the fork tags its release "v0.25.0-arm64". csv.first is the app
  # version, csv.second is the release tag.
  version "0.24.0,0.25.0-arm64"
  sha256 "91ad897213becbb57ac0ada20d83c47f2fe81cb2edc5774720f9c641a582b146"

  url "https://github.com/gingergeek8192/webtorrent-desktop/releases/download/v#{version.csv.second}/WebTorrent-v#{version.csv.first}.dmg"
  name "WebTorrent Desktop (Apple Silicon)"
  desc "Torrent streaming application built native for arm64"
  homepage "https://github.com/gingergeek8192/webtorrent-desktop"

  # Single-release fork; watch it for a newer arm64 build rather than guessing
  # a tag scheme. Emits "<app version>,<tag>" to match the version above.
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)-arm64$/i)
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"] || release["prerelease"]

        tag = release["tag_name"]&.[](regex, 0)
        next if tag.blank?

        asset = release["assets"]&.find { |a| a["name"]&.match?(/\.dmg$/i) }
        next if asset.blank?

        app = asset["name"][/WebTorrent-v?(\d+(?:\.\d+)+)\.dmg/i, 1]
        next if app.blank?

        "#{app},#{tag.delete_prefix("v")}"
      end
    end
  end

  # Same bundle (WebTorrent.app) and same CFBundleIdentifier
  # (io.webtorrent.webtorrent) as the homebrew-cask build, so the two cannot
  # coexist.
  conflicts_with cask: "webtorrent"
  # Thin arm64 binary (verified with `lipo -archs`) -- it cannot run on Intel.
  # The homebrew-cask formula ships x86_64 only and ends in `requires_rosetta`;
  # this cask exists precisely to avoid that translation layer.
  depends_on arch: :arm64
  # The bundle's own LSMinimumSystemVersion is 12.0; `brew audit` reads it out
  # of the artifact and fails if the cask claims no floor.
  depends_on macos: :monterey

  app "WebTorrent.app"

  # Same paths as the homebrew-cask webtorrent cask; the bundle id is identical.
  zap trash: [
    "~/Library/Application Support/io.webtorrent.webtorrent.ShipIt",
    "~/Library/Application Support/WebTorrent",
    "~/Library/Caches/io.webtorrent.webtorrent",
    "~/Library/Caches/io.webtorrent.webtorrent.ShipIt",
    "~/Library/Caches/WebTorrent",
    "~/Library/Cookies/io.webtorrent.webtorrent.binarycookies",
    "~/Library/HTTPStorages/io.webtorrent.webtorrent",
    "~/Library/Logs/WebTorrent",
    "~/Library/Preferences/ByHost/io.webtorrent.webtorrent.ShipIt.*.plist",
    "~/Library/Preferences/io.webtorrent.webtorrent-helper.plist",
    "~/Library/Preferences/io.webtorrent.webtorrent.plist",
    "~/Library/Saved Application State/io.webtorrent.webtorrent.savedState",
    "~/Library/WebKit/io.webtorrent.webtorrent",
  ]

  caveats <<~EOS
    This is an unofficial community build: ad-hoc signed, with no Developer ID
    and no notarization. Where Gatekeeper is enabled macOS will block the first
    launch -- approve it under System Settings > Privacy & Security, or install
    with --no-quarantine.

    It also ships a much newer Electron (39.x) than the official 0.24.0 build
    (27.x), so the bundled Chromium is considerably more current.
  EOS
end
