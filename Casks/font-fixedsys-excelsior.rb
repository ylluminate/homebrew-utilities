cask "font-fixedsys-excelsior" do
  version "3.09.10"
  sha256 "842f8fbf80f57d867aeb1d2988140d3ea8b4718e5f687035b0a3b66756df3899"

  url "https://github.com/kika/fixedsys/releases/download/v#{version}/FSEX302.ttf"
  name "Fixedsys Excelsior"
  desc "Revival of the Fixedsys bitmap font with programming ligatures"
  homepage "https://github.com/kika/fixedsys"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Same font family as the -alt cask (only ligatures differ) — cannot coexist.
  conflicts_with cask: "ylluminate/utilities/font-fixedsys-excelsior-alt"

  font "FSEX302.ttf"
end
