#!/bin/bash

# System Updates {{{
softwareupdate -l
sudo softwareupdate -ia --restart
# }}}

# Homebrew {{{
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Homebrew formulae {{{
# Bash {{{
brew install bash
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
chsh -s /usr/local/bin/bash
# }}}

# General {{{
brew install \
    vim neovim \
    git git-extras \
    wget \
    stow \
    shellcheck \
    hh \
    fasd \
    telnet \
    tree \
    gnupg \
    jq \
    htop \
    ncdu \
    bash-completion@2 \
    the_silver_searcher \
    watch \
    ctags \
    tmux \
    ack \
    pigz \
    xz
# }}}

# MacOS specific {{{
brew install \
    mas
# }}}

# Fun stuff {{{
brew install \
    fortune \
    cowsay \
    lolcat \
    spark
# }}}

# Music and Video {{{
brew install \
    mpv \
    ncmpcpp \
    mpc \
    mpd \
    mpdscribble
# }}}

# GNU {{{
brew install \
    coreutils \
    findutils \
    moreutils \
    gnu-sed \
    gnu-tar \
    iproute2mac
# }}}

# Replace outdated MacOS versions {{{
brew install \
    grep \
    openssh \
    curl \
    rsync
# }}}

# Office {{{
brew install \
    go glide \
    nvm \
    rabbitmq \
    redis \
    mysql \
    mongodb \
    solr

brew cask install \
    insomnia
# }}}

# Java {{{
brew tap caskroom/versions
brew cask install \
    java8
brew install \
    maven
# }}}

# NTFS Write Support {{{
brew cask install \
    osxfuse
brew install \
    ntfs-3g
# }}}

# Fonts {{{
brew tap caskroom/fonts
brew cask install \
    font/font-fira-code \
    font/font-fira-mono \
    font/font-fira-sans
# }}}
# }}}

# Postinstall steps {{{
. /usr/local/opt/nvm/nvm.sh && \
    mkdir "$HOME/.nvm" && \
    nvm install --lts && \
    npm install -g neovim
# }}}
# }}}

# Mac App Store {{{
mas signin
mas install 1039633667  # Irvue
# }}}

# Setup Variables {{{
# Locations {{{
DOWNLOAD_DIR="$HOME/Downloads/Software"
APPLICATIONS="/Applications"
LAUNCHD_HOME="$HOME/Library/LaunchAgents"
LOCAL_SRC="$HOME/.local/src"

mkdir -p "${DOWNLOAD_DIR}" "${APPLICATIONS}" "${LAUNCHD_HOME}" "${LOCAL_SRC}"
# }}}

# Programs {{{
UNZIP="unzip -q"
UNTAR="tar -xf"
# }}}
# }}}

# Create the install_app.sh script {{{
cat << 'EOF' > ./install_app.sh
#/bin/sh

VOLUME="$(hdiutil attach "$1" | grep Volumes | sed 's/.*\/Volumes\//\/Volumes\//')"
apps=( "$VOLUME/"*.app )
cp -rf "${apps[@]}" /Applications
hdiutil detach "$VOLUME"
EOF
# Replace the Applications folder with the value in the APPLICATIONS variable
sed -i "" "s|/Applications|${APPLICATIONS}|g" ./install_app.sh
chmod +x ./install_app.sh
# }}}

# Create the install_pkg.sh script {{{
cat << 'EOF' > ./install_pkg.sh
#/bin/sh

VOLUME="$(hdiutil attach "$1" | grep Volumes | sed 's/.*\/Volumes\//\/Volumes\//')"
pkgs=( "$VOLUME/"*.*pkg )
sudo installer -verbose -pkg "${pkgs[@]}" -target /
hdiutil detach "$VOLUME"
EOF
chmod +x ./install_pkg.sh
# }}}

# Install APP files {{{
# Firefox Nightly {{{
curl -L 'https://download.mozilla.org/?product=firefox-nightly-latest-ssl&os=osx&lang=en-US' -o "${DOWNLOAD_DIR}/firefox-nightly.dmg" && \
    ./install_app.sh "${DOWNLOAD_DIR}/firefox-nightly.dmg"
# }}}

# Firefox {{{
curl -L 'https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US' -o "${DOWNLOAD_DIR}/firefox-stable.dmg" && \
    ./install_app.sh "${DOWNLOAD_DIR}/firefox-stable.dmg"
# }}}

# Slack {{{
curl -L 'https://slack.com/ssb/download-osx' -o "${DOWNLOAD_DIR}/slack.dmg" && \
    ./install_app.sh "${DOWNLOAD_DIR}/slack.dmg"
# }}}

# Visual Studio Code {{{
curl -L 'https://go.microsoft.com/fwlink/?LinkID=620882' -o "${DOWNLOAD_DIR}/vscode.zip" && \
    ${UNZIP} "${DOWNLOAD_DIR}/vscode.zip" -d "${DOWNLOAD_DIR}" && \
    mv "${DOWNLOAD_DIR}/Visual Studio Code.app" "${APPLICATIONS}"
# }}}

# Spectacle {{{
curl -L 'https://s3.amazonaws.com/spectacle/downloads/Spectacle+1.2.zip' -o "${DOWNLOAD_DIR}/spectacle.zip" && \
    ${UNZIP} "${DOWNLOAD_DIR}/spectacle.zip" -d "${DOWNLOAD_DIR}" && \
    mv "${DOWNLOAD_DIR}/Spectacle.app" "${APPLICATIONS}"
# }}}

# Google Chrome {{{
curl -L 'https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg' -o "${DOWNLOAD_DIR}/googlechrome.dmg" && \
    ./install_app.sh "${DOWNLOAD_DIR}/googlechrome.dmg"
# }}}

# iTerm2 {{{
curl -L 'https://iterm2.com/downloads/stable/iTerm2-3_1_5.zip' -o "${DOWNLOAD_DIR}/iTerm2.zip" && \
    ${UNZIP} "${DOWNLOAD_DIR}/iTerm2.zip" -d "${DOWNLOAD_DIR}" && \
    mv "${DOWNLOAD_DIR}/iTerm.app" "${APPLICATIONS}"
# }}}

# Postman {{{
curl -L 'https://dl.pstmn.io/download/latest/osx' -o "${DOWNLOAD_DIR}/postman.zip" && \
    ${UNZIP} "${DOWNLOAD_DIR}/postman.zip" -d "${DOWNLOAD_DIR}" && \
    mv "${DOWNLOAD_DIR}/Postman.app" "${APPLICATIONS}"
# }}}

# GasMask {{{
curl -L 'http://gmask.clockwise.ee/files/gas_mask_0.8.5.zip' -o "${DOWNLOAD_DIR}/gasmask.zip" && \
    ${UNZIP} "${DOWNLOAD_DIR}/gasmask.zip" -d "${DOWNLOAD_DIR}" && \
    mv "${DOWNLOAD_DIR}/Gas Mask.app" "${APPLICATIONS}"
# }}}

# MySQL Workbench {{{
curl -L 'https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-6.3.10-macos-x86_64.dmg' -o "${DOWNLOAD_DIR}/mysql-workbench.dmg" && \
    ./install_app.sh "${DOWNLOAD_DIR}/Mysql-workbench.dmg"
# }}}

# Resilio Sync {{{
curl -L 'https://download-cdn.resilio.com/stable/osx/Resilio-Sync.dmg' -o "${DOWNLOAD_DIR}/resilio-sync.dmg" && \
    ./install_app.sh "${DOWNLOAD_DIR}/resilio-sync.dmg"
# }}}

# Virtual Box {{{
curl -L 'https://download.virtualbox.org/virtualbox/5.2.6/VirtualBox-5.2.6-120293-OSX.dmg' -o "${DOWNLOAD_DIR}/virtualbox.dmg" && \
    curl -L 'https://download.virtualbox.org/virtualbox/5.2.6/Oracle_VM_VirtualBox_Extension_Pack-5.2.6-120293.vbox-extpack' -o "${DOWNLOAD_DIR}/Oracle_VM_VirtualBox_Extension_Pack-5.2.6-120293.vbox-extpack" && \
    ./install_pkg.sh "${DOWNLOAD_DIR}/virtualbox.dmg" && \
    VBoxManage extpack install --replace "${DOWNLOAD_DIR}/Oracle_VM_VirtualBox_Extension_Pack-5.2.6-120293.vbox-extpack" && \
    VBoxManage extpack cleanup
# }}}

# Dash {{{
curl -L 'https://singapore.kapeli.com/downloads/v4/Dash.zip' -o "${DOWNLOAD_DIR}/dash.zip" && \
    ${UNZIP} "${DOWNLOAD_DIR}/dash.zip" -d "${DOWNLOAD_DIR}" && \
    mv "${DOWNLOAD_DIR}/Dash.app" "${APPLICATIONS}"
# }}}

# JetBrains {{{
curl -L 'https://download.jetbrains.com/idea/ideaIU-2017.3.3.dmg' -o "${DOWNLOAD_DIR}/intellij-idea.dmg"
curl -L 'https://download.jetbrains.com/webide/PhpStorm-2017.3.3.dmg' -o "${DOWNLOAD_DIR}/phpstorm.dmg"
# }}}

# Tunnelblick {{{
curl -L 'https://tunnelblick.net/release/Latest_Tunnelblick_Stable.dmg' -o "${DOWNLOAD_DIR}/tunnelblick.dmg" && \
    ./install_app.sh "${DOWNLOAD_DIR}/tunnelblick.dmg"
# }}}

# FortiClient SSLVPN {{{
curl -L 'https://d3gpjj9d20n0p3.cloudfront.net/forticlient/downloads/FortiClient_5.6.1.723_macosx.dmg' -o "${DOWNLOAD_DIR}/forticlient.dmg"
# }}}

# InsomniaX {{{
curl -L 'http://insomniax.semaja2.net/InsomniaX-2.1.8.tgz' -o "${DOWNLOAD_DIR}/insomniax.tgz" && \
    ${UNTAR} "${DOWNLOAD_DIR}/insomniax.tgz" -C "${DOWNLOAD_DIR}" && \
    mv InsomniaX.app "${APPLICATIONS}"
# }}}
# }}}

# Music setup {{{
mkdir "$HOME/.config/"{mpd,ncmpcpp,mpdscribble}
cat << 'EOF' > /tmp/music.patch
diff --git a/Formula/mpd.rb b/Formula/mpd.rb
index c0b7e03..5046549 100644
--- a/Formula/mpd.rb
+++ b/Formula/mpd.rb
@@ -125,6 +125,7 @@ class Mpd < Formula
         <array>
             <string>#{opt_bin}/mpd</string>
             <string>--no-daemon</string>
+            <string>${HOME}/.config/mpd/mpd.conf</string>
         </array>
         <key>RunAtLoad</key>
         <true/>
diff --git a/Formula/mpdscribble.rb b/Formula/mpdscribble.rb
index 7aa35c9..5f44c7c 100644
--- a/Formula/mpdscribble.rb
+++ b/Formula/mpdscribble.rb
@@ -41,6 +41,10 @@ class Mpdscribble < Formula
         <array>
             <string>#{opt_bin}/mpdscribble</string>
             <string>--no-daemon</string>
+            <string>--log</string>
+            <string>${HOME}/.config/mpdscribble/log</string>
+            <string>--conf</string>
+            <string>${HOME}/.config/mpdscribble/mpdscribble.conf</string>
         </array>
         <key>RunAtLoad</key>
         <true/>
EOF
sed -i "" "s|\${HOME}|${HOME}|g" /tmp/music.patch
pushd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/ && \
    git apply /tmp/music.patch && \
    brew rm mpd mpdscribble && \
    brew install mpd mpdscribble && \
    brew services start mpd && \
    brew services start mpdscribble
# }}}

# OSX {{{
# General UI/UX {{{
# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Jump to where you click in the scrollbar
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

# Set Monday as first day of the week
defaults write NSGlobalDomain AppleFirstWeekday -dict-add "gregorian" -int 2

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Save screenshots to Pictures/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true
# }}}

# Finder {{{
# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Open finder to Home
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file:///${HOME}/"

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Expand the following File Info panes:
# "General", "Open with", and "Sharing & Permissions"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true
# }}}

# Window Management {{{
# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# }}}

# Trackpad, gestures and input {{{
# Two finger click for context menu
defaults write NSGlobalDomain ContextMenuGesture -int 1

# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Enable AppExpose gesture
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Text Correction {{{
# Disable automatic capitalization as it's annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it's annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# }}}

# Keyboard {{{
# Set keyboard repeat rate
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 1

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# }}}

# Sound, Dictation and Siri {{{
# Beep when changing volume
defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 1

# Disable dictation
defaults write com.apple.assistant.support "Dictation Enabled" -bool false
defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMMasterDictationEnabled -bool false
defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs KeywordOptional -int -1

# Type to siri
defaults write com.apple.Siri TypeToSiriEnabled -bool true
# }}}
# }}}

# Dock, Menu Bar, Mission Control, Spaces {{{
# Dark menu, buttons and windows
defaults write NSGlobalDomain AppleAquaColorVariant -int 6

# Dark dock and menu bar
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Minimize/Maximize effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize to application windows
defaults write com.apple.dock minimize-to-application -bool true

# Dock position
defaults write com.apple.dock orientation -string "left"

# Group windows by applications in Expose
defaults write com.apple.dock "expose-group-apps" -bool true

# Dashboard as an overlay
defaults write com.apple.dashboard "dashboard-enabled-state" -int 3

# Don't arrange spaces based on recency
defaults write com.apple.dock "mru-spaces" -bool false

# Hot Corners {{{
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Launchpad bottom left
defaults write com.apple.dock "wvous-bl-corner" -int 11;
defaults write com.apple.dock "wvous-bl-modifier" -int 0;
# Desktop bottom right
defaults write com.apple.dock "wvous-br-corner" -int 4;
defaults write com.apple.dock "wvous-br-modifier" -int 0;
# Mission Control top left
defaults write com.apple.dock "wvous-tl-corner" -int 2;
defaults write com.apple.dock "wvous-tl-modifier" -int 0;
# Application Windows top right
defaults write com.apple.dock "wvous-tr-corner" -int 3;
defaults write com.apple.dock "wvous-tr-modifier" -int 0;

defaults write com.apple.systempreferences "DefaultExposeTab" -string "ExposeTab"
# }}}
# }}}

# Spotlight {{{
defaults write com.apple.spotlight orderedItems -array \
    '{ "enabled" = 1; "name" = "APPLICATIONS"; }' \
    '{ "enabled" = 1; "name" = "MENU_SPOTLIGHT_SUGGESTIONS"; }' \
    '{ "enabled" = 1; "name" = "MENU_CONVERSION"; }' \
    '{ "enabled" = 1; "name" = "MENU_EXPRESSION"; }' \
    '{ "enabled" = 0; "name" = "MENU_DEFINITION"; }' \
    '{ "enabled" = 1; "name" = "SYSTEM_PREFS"; }' \
    '{ "enabled" = 1; "name" = "DOCUMENTS"; }' \
    '{ "enabled" = 1; "name" = "DIRECTORIES"; }' \
    '{ "enabled" = 1; "name" = "PRESENTATIONS"; }' \
    '{ "enabled" = 1; "name" = "SPREADSHEETS"; }' \
    '{ "enabled" = 1; "name" = "PDF"; }' \
    '{ "enabled" = 0; "name" = "MESSAGES"; }' \
    '{ "enabled" = 0; "name" = "CONTACT"; }' \
    '{ "enabled" = 0; "name" = "EVENT_TODO"; }' \
    '{ "enabled" = 1; "name" = "IMAGES"; }' \
    '{ "enabled" = 0; "name" = "BOOKMARKS"; }' \
    '{ "enabled" = 1; "name" = "MUSIC"; }' \
    '{ "enabled" = 1; "name" = "MOVIES"; }' \
    '{ "enabled" = 0; "name" = "FONTS"; }' \
    '{ "enabled" = 1; "name" = "MENU_OTHER"; }'

# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null
# }}}

for app in "cfprefsd" \
    "Dock" \
    "Finder" \
    "SystemUIServer"; do
    killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
# }}}

# Git {{{
# oh-my-git {{{
git clone git@hashhar.github.com:hashhar/oh-my-git.git "${LOCAL_SRC}/oh-my-git"
pushd "${LOCAL_SRC}/oh-my-git" && \
    git checkout unicode
popd
# }}}

# Swagger-UI {{{
git clone git@github.com:swagger-api/swagger-ui.git "${HOME}/code/tools/swagger-ui"
pushd "${HOME}/code/tools/swagger-ui" && \
    git checkout v2.1.0
popd
# }}}
# }}}

# Jabong Repos {{{
export GEM_HOME="$(ruby -e 'print Gem.user_dir')"
gem --user-install --no-document octokit
_curdir="$(pwd)"
mkdir -pv ~/code/src/github.com/jabong/_ALL/ && \
    pushd ~/code/src/github.com/jabong/_ALL/ && \
    ruby "${_curdir}/get-repo-list.rb" | sed -e 's/git@github.com/git@jabong.github.com/' | xargs -n1 git clone
# }}}

# vim: set fen fdm=marker sw=4 sts=4 ts=4 et:
