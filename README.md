# dotfiles

`xcode-select --install`

`git clone git@github.com:pwthai/dotfiles.git ~/dotfiles`

Install dependencies and stow the dotfiles:

`./install`

Run without verbose Homebrew bundle output:

`./install --quiet`

The installer initializes OpenCode agents, TPM tmux plugins, and Neovim Lazy
plugins. Ghostty's macOS tabs appear after you open a second tab.

## Desktop bar

SketchyBar replaces the native menu bar with a compact Akane bar.
The numbered workspace pills switch AeroSpace workspaces; the golden pill is the
focused workspace. The installer enables macOS menu-bar auto-hide with:

```sh
defaults write NSGlobalDomain _HIHideMenuBar -bool true
killall SystemUIServer
```

To restore the native menu bar, run:

```sh
defaults write NSGlobalDomain _HIHideMenuBar -bool false
killall SystemUIServer
```

SketchyBar and the focused-window borders start from AeroSpace. To apply bar
changes without logging out, run `~/.config/sketchybar/start.sh`.

The Apple icon opens system actions. Restart, shut down, log out, sleep, and
Force Quit first show a native confirmation dialog. macOS may ask SketchyBar
(or the terminal used for testing) for Automation and Accessibility permission
to control System Events. Force Quit then sends Option-Command-Escape to open
Apple's native picker, which provides its own final confirmation.

Volume, battery, and Spotify modules open compact detail popups. Wi-Fi,
Bluetooth, and Focus open the main native Control Center without changing a
radio or power state. SketchyBar may request Automation and Accessibility
permission for this UI scripting. If the Control Center launcher works from
Terminal but not from the bar, add the actual Homebrew SketchyBar binary
(`/opt/homebrew/bin/sketchybar`, resolving its symlink if applicable) in
System Settings → Privacy & Security → Accessibility, then allow Automation
for System Events if macOS prompts. Do not reset TCC or change permissions by
script. Wi-Fi status uses read-only `ipconfig` link detection and Bluetooth
status uses read-only `blueutil --power`; Focus remains neutral because macOS
has no stable public status API for it.

macOS may still reveal its auto-hidden menu bar when the pointer reaches the
top screen edge. This is standard system behavior; the setup does not use a
process-killing or overlay workaround to suppress it.
