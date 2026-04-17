cask "recordly" do
  version :latest
  sha256 :no_check

  on_arm do
    url "https://github.com/webadderall/Recordly/releases/latest/download/Recordly-arm64.dmg"
  end
  on_intel do
    url "https://github.com/webadderall/Recordly/releases/latest/download/Recordly-x64.dmg"
  end

  name "Recordly"
  desc "Screen and audio recorder"
  homepage "https://github.com/webadderall/Recordly"

  auto_updates true

  app "Recordly.app"

  zap trash: [
    "~/Library/Application Support/Recordly",
    "~/Library/Caches/com.webadderall.Recordly",
    "~/Library/Logs/Recordly",
    "~/Library/Preferences/com.webadderall.Recordly.plist",
    "~/Library/Saved Application State/com.webadderall.Recordly.savedState",
  ]
end
