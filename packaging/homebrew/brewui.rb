cask "brewui" do
  version "0.0.2"
  sha256 "74909d510f64aa5d68ae91cc479492e346d019694e493af6f9fa4e453a223e54"

  url "https://github.com/buiducnhat/brewui/releases/download/v#{version}/BrewUI-#{version}.zip"
  name "BrewUI"
  desc "Native macOS Homebrew package manager"
  homepage "https://github.com/buiducnhat/brewui"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "BrewUI.app"

  # No zap stanza required
end
