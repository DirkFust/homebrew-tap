# homebrew-tap

Homebrew tap for my personal macOS apps. The casks live here, and so do the
release binaries — the app sources are in private repositories, and a cask
downloads over plain unauthenticated curl, which cannot reach assets attached
to a private repo.

## Install

```sh
brew tap DirkFust/tap
HOMEBREW_CASK_OPTS="--no-quarantine" brew install --cask summon
```

Put `export HOMEBREW_CASK_OPTS="--no-quarantine"` in your shell profile so it
applies to upgrades too.

## Upgrade

```sh
brew upgrade --cask summon
```

## Why `--no-quarantine`

These apps are signed with a self-signed certificate rather than an Apple
Developer ID, so they are not notarized. Homebrew Cask attaches
`com.apple.quarantine` to everything it installs, and Gatekeeper refuses
non-notarized bundles that carry that attribute — since macOS 15 without even a
Control-click bypass. `--no-quarantine` tells Cask not to attach it.

The signing certificate is not about Gatekeeper: it keeps the code signature's
designated requirement stable across builds, so macOS does not drop the
Accessibility grant on every update.

## Casks

| Cask     | Description                                                                |
| -------- | -------------------------------------------------------------------------- |
| `summon` | Menu bar app that activates, places and resizes windows from the keyboard   |
