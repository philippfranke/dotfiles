#!/usr/bin/env bash
echo ''
echo "Please enter your preferred hostname:"
read user_hostname

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo scutil --set ComputerName "${user_hostname}"
sudo scutil --set HostName "${user_hostname}"
sudo scutil --set LocalHostName "${user_hostname}"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${user_hostname}"

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

chflags nohidden ~/Library
defaults write NSGlobalDomain KeyRepeat -int 0
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.Safari ShowFavoritesBar -bool false

defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
defaults write com.apple.dock show-process-indicators -bool true

defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.dock dashboard-in-overlay -bool true

defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide -bool true

sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"

defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

defaults write com.apple.terminal StringEncodings -array 4
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
