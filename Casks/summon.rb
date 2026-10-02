cask "summon" do
  version "1.4.4"
  sha256 "2ecc9be96f41baf6b7c2c512ad2c9937aefad03cc5e39ed9d090de46a9f484da"

  url "https://github.com/DirkFust/homebrew-tap/releases/download/summon-v#{version}/Summon-#{version}.zip"
  name "Summon"
  desc "Menu bar app that activates, places and resizes windows from the keyboard"
  homepage "https://github.com/DirkFust/homebrew-tap"

  depends_on macos: :tahoe

  app "Summon.app"

  # Cask quarantines everything it installs, and Gatekeeper refuses a
  # non-notarized bundle carrying that attribute. Strip it for this app only.
  # The alternative, HOMEBREW_CASK_OPTS="--no-quarantine", is the one knob
  # Homebrew 6 still offers and it is global — it would disable quarantine for
  # every other cask too. `xattr -dr` exits 0 whether or not the attribute is
  # present, so this needs no failure handling. Declarative steps, because
  # Homebrew 7 deprecates the Ruby `postflight` block; `{{appdir}}` is
  # expanded by Homebrew at install time.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Summon.app"]
  end

  uninstall quit: "com.dirk.summon"

  zap trash: "~/Library/Preferences/com.dirk.summon.plist"
end
