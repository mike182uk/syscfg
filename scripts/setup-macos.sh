#!/usr/bin/env sh

# Default shell

FISH_PATH=$(command -v fish)
if [ -n "$FISH_PATH" ]; then
	if ! grep -q "$FISH_PATH" /etc/shells; then
		echo "$FISH_PATH" | sudo tee -a /etc/shells
	fi
	if [ "$SHELL" != "$FISH_PATH" ]; then
		chsh -s "$FISH_PATH"
	fi
fi

# Hostname

if [ -n "$HOSTNAME" ]; then
	sudo scutil --set ComputerName "$HOSTNAME"
	sudo scutil --set LocalHostName "$HOSTNAME"
	sudo scutil --set HostName "$HOSTNAME"
	dscacheutil -flushcache
fi

# Appearance

defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Dialogs

defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -boolean true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -boolean true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -boolean true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -boolean true

# Dock

defaults write com.apple.dock autohide -boolean true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock launchanim -boolean false
defaults write com.apple.dock minimize-to-application -boolean true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-process-indicators -boolean true
defaults write com.apple.dock show-recents -boolean false
defaults write com.apple.dock showhidden -boolean true
defaults write com.apple.dock tilesize -integer 50
# Hot corners: bl = bottom-left, br = bottom-right
# Actions: 1 = disabled, 4 = show desktop
defaults write com.apple.dock wvous-bl-corner -integer 4
defaults write com.apple.dock wvous-bl-modifier -integer 0
defaults write com.apple.dock wvous-br-corner -integer 1
defaults write com.apple.dock wvous-br-modifier -integer 0

# Finder

defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder _FXSortFoldersFirst -boolean true
defaults write com.apple.finder AppleShowAllFiles -boolean true
defaults write com.apple.finder FXEnableExtensionChangeWarning -boolean false
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write NSGlobalDomain AppleShowAllExtensions -boolean true

# Keyboard

defaults write NSGlobalDomain KeyRepeat -integer 2
defaults write NSGlobalDomain InitialKeyRepeat -integer 15

# Text input

defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -boolean false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -boolean false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -boolean false

# Trackpad

defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -boolean false
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -boolean true
defaults write NSGlobalDomain com.apple.swipescrolldirection -boolean false

# Restart affected applications

for app in "Dock" \
	"Finder"; do
	killall "${app}" >/dev/null 2>&1
done
