cask "font-fixedsys-excelsior-alt" do
  version "3.09.10"
  sha256 "21b801fe4179dc884a9836d1fbd570ce83249d77204a0a017fbae14aa2dea132"

  url "https://github.com/kika/fixedsys/releases/download/v#{version}/FSEX302-alt.ttf"
  name "Fixedsys Excelsior (alt ligatures)"
  desc "Fixedsys Excelsior with alternate programming ligatures"
  homepage "https://github.com/kika/fixedsys"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Same font family as font-fixedsys-excelsior — only the ligatures differ
  # (alt ligates `<=` instead of `=<`), so the two cannot coexist.
  conflicts_with cask: "ylluminate/utilities/font-fixedsys-excelsior"

  font "FSEX302-alt.ttf"
end
