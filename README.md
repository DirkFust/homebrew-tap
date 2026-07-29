# homebrew-tap

Homebrew tap for my personal macOS apps. The casks live here, and so do the
release binaries — the app sources are in private repositories, and a cask
downloads over plain unauthenticated curl, which cannot reach assets attached
to a private repo.

## Install

```sh
brew tap DirkFust/tap
brew install --cask summon
```

## Upgrade

```sh
brew upgrade --cask summon
```

## Why these casks strip quarantine

These apps are signed with a self-signed certificate rather than an Apple
Developer ID, so they are not notarized. Homebrew Cask attaches
`com.apple.quarantine` to everything it installs, and Gatekeeper refuses
non-notarized bundles that carry that attribute — since macOS 15 without even a
Control-click bypass.

Each cask therefore removes the attribute from its own app in a `postflight`
block. The alternative is `HOMEBREW_CASK_OPTS="--no-quarantine"`, the only knob
Homebrew 6 still offers now that the per-command flag is gone — and it is
global, disabling quarantine for every other cask on the machine. Confining it
to one app is the whole point.

If an app does end up quarantined anyway, strip it by hand:

```sh
xattr -dr com.apple.quarantine /Applications/Summon.app
```

The signing certificate is not about Gatekeeper: it keeps the code signature's
designated requirement stable across builds, so macOS does not drop the
Accessibility grant on every update.

## Casks

| Cask     | Description                                                                |
| -------- | -------------------------------------------------------------------------- |
| `summon` | Menu bar app that activates, places and resizes windows from the keyboard   |
