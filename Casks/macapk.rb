cask "macapk" do
  version "1.0.2303"
  sha256 "af32b4d7e972f761629549818759cf1866d8f7c3a89b6e96b1bc8de585565d39"

  url "https://github.com/kksimp/Mac.apk/releases/download/v#{version}/macapk.dmg"
  name "Mac.apk"
  desc "Run Android apps natively on Apple Silicon without an emulator or VM"
  homepage "https://projects.voltare.us/macapk.html"

  # Upstream ships a new alpha build every day or two and the app has no
  # self-updater ("Mac.apk doesn't update itself" -- wiki/Installation), so this
  # cask is pinned and bumped by .github/workflows/autobump.yml.
  livecheck do
    url :url
    strategy :github_latest
  end

  # arm64-only binary, LSMinimumSystemVersion 26.4 in the bundle.
  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Mac.apk.app"

  # The first two paths are documented by upstream (wiki: Managing-Apps,
  # Reporting-Problems); the rest are the standard per-bundle-id locations.
  zap trash: [
    "~/Library/Application Support/MacApk",
    "~/Library/Caches/org.macapk.launcher",
    "~/Library/HTTPStorages/org.macapk.launcher",
    "~/Library/Logs/macapk",
    "~/Library/Preferences/org.macapk.launcher.plist",
    "~/Library/Saved Application State/org.macapk.launcher.savedState",
  ]

  caveats <<~EOS
    After first launch, click Install next to "Runtime:" in the Mac.apk window.

    Each Android app you install becomes its own .app bundle; those are not
    tracked by this cask. Remove them from the Mac.apk window (right-click >
    Uninstall) so their data is cleaned up too.

    `brew uninstall --zap` deletes ~/Library/Application Support/MacApk, which
    holds every installed Android app's data and saves.
  EOS
end
