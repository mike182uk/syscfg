#!/usr/bin/env sh

# Dock

defaults write com.apple.dock autohide -boolean true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock launchanim -boolean false
defaults write com.apple.dock minimize-to-application -boolean true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock show-recents -boolean false
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock tilesize -integer 50
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0

# Finder

defaults write com.apple.finder _FXSortFoldersFirst -boolean true
defaults write com.apple.finder AppleShowAllFiles -boolean true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Trackpad

defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Restart affected applications

for app in "Dock" \
	"Finder"; do
	killall "${app}" &> /dev/null
done
