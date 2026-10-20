cask "recordly" do
  arch arm: "arm64", intel: "x64"

  version "1.4.0"
  sha256 arm:   "520ee1d5570f2342e126306eda84b95e442c844b6f0e84c6e81c208445be8cc4",
         intel: "f478afef1c37adb8d4df9e0c0cdecde99df6f3131e34629ad3f5c3c8c226d1b5"

  url "https://github.com/webadderall/Recordly/releases/download/v#{version}/Recordly-#{arch}.dmg"
  name "Recordly"
  desc "Screen and audio recorder"
  homepage "https://github.com/webadderall/Recordly"

  # github_latest skips prereleases such as v1.4.0-beta.1.
  livecheck do
    url :url
    strategy :github_latest
  end

  # The app updates itself (Electron + Squirrel, app-update.yml in Resources);
  # the cask is still bumped by .github/workflows/autobump.yml so a fresh
  # install gets the current build with a verified checksum.
  auto_updates true
  depends_on macos: :monterey

  app "Recordly.app"

  # Bundle id is dev.recordly.app (read from the shipped Info.plist).
  zap trash: [
    "~/Library/Application Support/Recordly",
    "~/Library/Caches/dev.recordly.app",
    "~/Library/Caches/dev.recordly.app.ShipIt",
    "~/Library/HTTPStorages/dev.recordly.app",
    "~/Library/Logs/Recordly",
    "~/Library/Preferences/dev.recordly.app.plist",
    "~/Library/Saved Application State/dev.recordly.app.savedState",
  ]
end
