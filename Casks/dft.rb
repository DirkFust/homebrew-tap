cask "dft" do
  version "0.13.1"
  sha256 "7680442bc5a9b97a820888e2252693745d9ea0fd7624f839b5752d13d15259db"

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

  # A steps block, not the deprecated `postflight do`: Homebrew 6 warns on the
  # legacy flight blocks and only the declarative step DSL stays quiet. Paths
  # reach the steps through the `{{appdir}}` template token — `#{appdir}` is a
  # cask-DSL method the steps DSL deliberately does not expose.
  postflight_steps do
    # Cask quarantines everything it installs, and Gatekeeper refuses a
    # non-notarized bundle carrying that attribute. Strip it for this app only.
    # The alternative, HOMEBREW_CASK_OPTS="--no-quarantine", is the one knob
    # Homebrew 6 still offers and it is global — it would disable quarantine for
    # every other cask too. `xattr -dr` exits 0 whether or not the attribute is
    # present, so this needs no failure handling.
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/DFT.app"]
    # Launch Services scans /Applications on its own schedule; registering by
    # hand makes the dft:// scheme and the "Diff with DFT"
    # Finder service work immediately after the install rather than eventually.
    #
    # `must_succeed: false` because this is a convenience, not a precondition:
    # `lsregister -f` exits 1 when its Spotlight side-scan of a bundle that
    # appeared moments ago returns -10822 ("failed to scan ...: -10822 from
    # spotlight") — the Launch Services registration itself still went through.
    # As a fatal step it aborted the install *and* the rollback that follows it,
    # leaving the machine with no DFT.app at all.
    run "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
        args: ["-f", "{{appdir}}/DFT.app"],
        must_succeed: false
  end

  uninstall quit: "cloud.fust.dft"

  zap trash: [
    "~/Library/Application Support/dft",
    "~/Library/Preferences/cloud.fust.dft.plist",
  ]
end
