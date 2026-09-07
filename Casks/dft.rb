cask "dft" do
  version "0.9.1"
  sha256 "f2dcc4cdafc3cd1fcd5c637f377332e1f5feb7dbbc73da26027e393a72c92f8f"

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
    run "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
        args: ["-f", "{{appdir}}/DFT.app"]
  end

  uninstall quit: "cloud.fust.dft"

  zap trash: [
    "~/Library/Application Support/dft",
    "~/Library/Preferences/cloud.fust.dft.plist",
  ]
end
