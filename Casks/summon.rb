cask "summon" do
  version "1.4.2"
  sha256 "24351bc00a72ba86e145a06763a3c4f6d44111806fe1f977d0c41e21e4649317"

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
  # present, so this needs no failure handling.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Summon.app"]
  end

  uninstall quit: "com.dirk.summon"

  zap trash: "~/Library/Preferences/com.dirk.summon.plist"
end
