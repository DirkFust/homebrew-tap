cask "dft" do
  version "0.7.0"
  sha256 "8258a50788ad5519a96c5e5552bd487356c66597e82cbbbd716b7683a4850426"

  url "https://github.com/DirkFust/homebrew-tap/releases/download/dft-v#{version}/DFT-#{version}.zip"
  name "DFT"
  desc "Native macOS diff tool with a CLI and a GUI in one binary"
  homepage "https://github.com/DirkFust/homebrew-tap"

  # A bare symbol already means "this version or newer"; the string form
  # (">= :sequoia") is deprecated and warns on every brew command.
  depends_on macos: :sequoia

  app "DFT.app"
  # One binary, two front-ends: the CLI `dft` is the very executable
  # inside the bundle, so it is linked rather than shipped twice. `make install`
  # puts a second copy at /usr/local/bin/dft — if both exist, PATH order
  # decides which one runs.
  binary "#{appdir}/DFT.app/Contents/MacOS/dft"

  postflight do
    # Cask quarantines everything it installs, and Gatekeeper refuses a
    # non-notarized bundle carrying that attribute. Strip it for this app only.
    # The alternative, HOMEBREW_CASK_OPTS="--no-quarantine", is the one knob
    # Homebrew 6 still offers and it is global — it would disable quarantine for
    # every other cask too. `xattr -dr` exits 0 whether or not the attribute is
    # present, so this needs no failure handling.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/DFT.app"]
    # Launch Services scans /Applications on its own schedule; registering by
    # hand makes the dft:// scheme and the "Diff with DFT"
    # Finder service work immediately after the install rather than eventually.
    lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/" \
                 "LaunchServices.framework/Support/lsregister"
    system_command lsregister, args: ["-f", "#{appdir}/DFT.app"]
  end

  uninstall quit: "cloud.fust.dft"

  zap trash: [
    "~/Library/Application Support/dft",
    "~/Library/Preferences/cloud.fust.dft.plist",
  ]
end
