cask "twig" do
  version "0.1.0"
  sha256 "0b47e8d667b8f10861489fa0b79bd7cd3b6bf0fe97a2b5203fe0fef35001848e"

  url "https://github.com/DirkFust/homebrew-tap/releases/download/twig-v#{version}/Twig-#{version}.zip"
  name "Twig"
  desc "Folder graph file manager on an infinite canvas"
  homepage "https://github.com/DirkFust/homebrew-tap"

  # A bare symbol already means "this version or newer"; the string form
  # (">= :golden_gate") is deprecated and warns on every brew command.
  depends_on macos: :golden_gate

  app "Twig.app"

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
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/Twig.app"]
    # Launch Services scans /Applications on its own schedule; registering by
    # hand makes Twig show up in Launchpad, Spotlight and "Open With"
    # immediately after the install rather than eventually.
    #
    # `must_succeed: false` because this is a convenience, not a precondition:
    # `lsregister -f` exits 1 when its Spotlight side-scan of a bundle that
    # appeared moments ago returns -10822 ("failed to scan ...: -10822 from
    # spotlight") — the Launch Services registration itself still went through.
    # As a fatal step it would abort the install *and* the rollback that follows
    # it, leaving the machine with no Twig.app at all.
    run "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
        args:         ["-f", "{{appdir}}/Twig.app"],
        must_succeed: false
  end

  uninstall quit: "cloud.fust.twig"

  zap trash: [
    "~/Library/Application Support/Twig",
    "~/Library/Preferences/cloud.fust.twig.plist",
  ]
end
