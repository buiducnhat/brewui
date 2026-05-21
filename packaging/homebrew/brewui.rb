cask "brewui" do
  version "0.0.1"
  sha256 "416f7f78ccd53522a6a3facdd1f8d164abb48a70a3a1172e4f37e5dda50eb869"

  url "https://github.com/buiducnhat/brewui/releases/download/v#{version}/BrewUI-#{version}.zip"
  name "BrewUI"
  desc "Native macOS Homebrew package manager"
  homepage "https://github.com/buiducnhat/brewui"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "BrewUI.app"

  # No zap stanza required
end
