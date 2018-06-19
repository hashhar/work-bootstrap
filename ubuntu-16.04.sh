#!/bin/bash

STOW_DIR='/usr/local/stow'
INSTALL='sudo apt-get install -y'

# Update {{{
sudo apt update && \
    sudo apt upgrade
# }}}

# PPAs {{{
# Neovim
sudo add-apt-repository -y ppa:neovim-ppa/stable
# FASD
sudo add-apt-repository -y ppa:aacebedo/fasd
# Paper
sudo add-apt-repository -y ppa:snwh/pulp
# Resilio Sync
echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
wget -qO - https://linux-packages.resilio.com/resilio-sync/key.asc | sudo apt-key add -
# FortiClient
echo "deb http://styrion.at/apt/ ./" | sudo tee /etc/apt/sources.list.d/styrion.list
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2FAB19E7CCB7F415
# Java
sudo add-apt-repository -y ppa:webupd8team/java
# RabbitMQ
echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
# Graysky
sudo add-apt-repository -y ppa:graysky/utils
# MongoDB
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
# Hstr
sudo add-apt-repository -y ppa:ultradvorka/ppa
# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Zeal
sudo add-apt-repository -y ppa:zeal-developers/ppa

# Install
sudo apt update && \
    $INSTALL neovim ruby-neovim \
    fasd \
    paper-cursor-theme paper-gtk-theme paper-icon-theme \
    resilio-sync \
    forticlient-sslvpn openfortigui \
    oracle-java8-installer \
    rabbitmq-server \
    profile-sync-daemon profile-cleaner \
    mongodb-org \
    hh \
    docker-ce \
    zeal
# }}}

# Packages from main repos {{{
$INSTALL apt-file \
    arc-theme \
    conky-all \
    exuberant-ctags \
    feh \
    git git-extras git-gui \
    gnupg2 \
    i3 \
    iotop \
    jq \
    lolcat \
    lxappearance \
    maven \
    mpc mpd mpdris2 mpdscribble mpv \
    mycli mysql-client mysql-server mysql-workbench \
    ncdu \
    ncmpcpp \
    neofetch \
    ntfs-3g \
    ssh \
    pavucontrol \
    php-pear php7.0 php7.0-dev \
    ppa-purge \
    python-pip python-dev python3 python3-pip python3-dev \
    rofi \
    rxvt-unicode-256color \
    scrot \
    shellcheck \
    silversearcher-ag \
    stow \
    tmux \
    trash-cli \
    tree \
    vim \
    wget \
    virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso \
    weechat \
    xbacklight \
    xclip \
    xdotool \
    xsel
# }}}

# Packages from deb files {{{
mkdir -p "$HOME/Downloads/Software" && \
    pushd "$HOME/Downloads/Software" && \
    curl -L 'https://launchpad.net/~aacebedo/+archive/ubuntu/fasd/+build/9615511/+files/fasd_1.0.1-3~233~ubuntu16.10.1_amd64.deb' -o fasd.deb && \
    curl -L 'https://go.microsoft.com/fwlink/?LinkID=760868' -o vscode.deb && \
    curl -L 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' -o google-chrome.deb && \
    curl -L 'https://downloads.slack-edge.com/linux_releases/slack-desktop-2.8.0-amd64.deb' -o slack.deb
sudo dpkg -i ./*.deb
$INSTALL -f
popd
# }}}

# Opt {{{
sudo chown -R "$USER:$USER" /opt
# Redis {{{
pushd /opt && \
    wget 'http://download.redis.io/releases/redis-stable.tar.gz' && \
    tar xf redis-stable.tar.gz -C /opt && \
    cd redis-stable && \
    PREFIX="$STOW_DIR/redis" make -j4 && \
    sudo PREFIX="$STOW_DIR/redis" make install && \
    cd "$STOW_DIR" && \
    sudo stow -R redis
popd
# }}}

# Golang {{{
pushd /opt && \
    curl -L 'https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz' -o go1.9.2.linux-amd64.tar.gz && \
    sudo mkdir -p "$STOW_DIR/golang" && \
    sudo tar xf go1.9.2.linux-amd64.tar.gz -C "$STOW_DIR/golang" && \
    cd "$STOW_DIR" && \
    sudo stow -R golang
popd
# }}}

# Firefox Nightly {{{
pushd /opt && \
    curl -L 'https://download.mozilla.org/?product=firefox-nightly-latest-ssl&os=linux64&lang=en-US' -o firefox-nightly.tar.bz && \
    tar xf firefox-nightly.tar.bz -C /opt && \
    sudo ln -s /opt/firefox/firefox /usr/local/bin/nightly
    cat << 'EOF' > /opt/firefox/nightly.desktop
[Desktop Entry]
Version=1.0
Name=Firefox Nightly
Comment=Browse the World Wide Web
GenericName=Web Browser
Keywords=Internet;WWW;Browser;Web;Explorer
Exec=/opt/firefox/firefox %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/opt/firefox/browser/icons/mozicon128.png
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupNotify=true
Actions=NewWindow;NewPrivateWindow;

[Desktop Action NewWindow]
Name=Open a New Window
Exec=/opt/firefox/firefox -new-window

[Desktop Action NewPrivateWindow]
Name=Open a New Private Window
Exec=/opt/firefox/firefox -private-window
EOF
sudo desktop-file-install /opt/firefox/nightly.desktop
popd
# }}}

# Siege {{{
pushd /opt && \
    curl -L 'http://download.joedog.org/siege/siege-latest.tar.gz' -o siege.tar.gz && \
    tar xf siege.tar.gz -C /opt && \
    cd /opt/siege-4.0.4 && \
    ./configure --prefix="$STOW_DIR/siege" && \
    PREFIX="$STOW_DIR/siege" make && \
    sudo PREFIX="$STOW_DIR/siege" make install && \
    cd "$STOW_DIR" && \
    sudo stow -R siege
popd
# }}}

# Postman {{{
pushd /opt && \
    curl -L 'https://dl.pstmn.io/download/latest/linux64' -o Postman.tar.gz && \
    tar xf Postman.tar.gz -C /opt && \
    sudo ln -s /opt/Postman/Postman /usr/local/bin/postman
popd
# }}}

# PHPStorm {{{
pushd /opt && \
    curl -L 'https://download.jetbrains.com/webide/PhpStorm-2017.3.1.tar.gz' -o phpstorm.tar.gz && \
    tar xf phpstorm.tar.gz -C /opt
popd
# }}}

# Solr {{{
pushd /opt && \
    curl -L 'http://www-eu.apache.org/dist/lucene/solr/7.1.0/solr-7.1.0.tgz' -o solr.tgz && \
    tar xf solr.tgz -C /opt && \
    sudo ln -s /opt/solr-7.1.0/bin/solr /usr/local/bin/solr
popd
# }}}
# }}}

# Git {{{
# i3gaps {{{
$INSTALL libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev

pushd "$HOME/.local/src" && \
    git clone https://www.github.com/Airblader/i3 i3-gaps && \
    cd i3-gaps && \
    git checkout gaps && \
    autoreconf --force --install && \
    rm -rf build/ && \
    mkdir -p build && \
    cd build/ && \
    ../configure --prefix="$STOW_DIR/i3-gaps" --sysconfdir=/etc --disable-sanitizers && \
    make && \
    sudo make install && \
    cd "$STOW_DIR" && \
    sudo stow -R i3-gaps
popd
# }}}

# i3lock-clock {{{
$INSTALL libxcb-dpms0-dev libpam0g-dev

cat << 'EOF' > /tmp/i3lock-clock.patch
diff --git a/Makefile b/Makefile
index 26ec990..eb264a7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 TOPDIR=$(shell pwd)
 
 INSTALL=install
-PREFIX=/usr
-SYSCONFDIR=/etc
+PREFIX?=/usr
+SYSCONFDIR?=/etc
 PKG_CONFIG=pkg-config
 
 # Check if pkg-config is installed, we need it for building CFLAGS/LIBS
EOF

pushd "$HOME"/.local/src && \
    git clone https://github.com/Lixxia/i3lock i3lock-clock && \
    cd i3lock-clock && \
    mv /tmp/i3lock-clock.patch "$HOME"/.local/src/i3lock-clock && \
    patch -p1 Makefile i3lock-clock.patch && \
    export PREFIX="$STOW_DIR/i3lock-clock" make && \
    sudo PREFIX="$STOW_DIR/i3lock-clock" make install && \
    cd "$STOW_DIR" && \
    sudo stow -R i3lock-clock
popd
# }}}

# Compton {{{
$INSTALL libxcomposite-dev libxdamage-dev libxrandr-dev libxinerama-dev libconfig-dev libdbus-1-dev libgl1-mesa-dev asciidoc-base
pushd "$HOME/.local/src" && \
    git clone https://github.com/chjj/compton && \
    cd compton && \
    PREFIX="$STOW_DIR/compton" make && \
    PREFIX="$STOW_DIR/compton" make docs && \
    sudo PREFIX="$STOW_DIR/compton" make install && \
    cd "$STOW_DIR" && \
    sudo stow -R compton
popd
# }}}

# Cava {{{
$INSTALL libfftw3-dev libasound2-dev libncursesw5-dev libpulse-dev
pushd "$HOME/.local/src" && \
    git clone https://github.com/karlstav/cava && \
    cd cava && \
    ./autogen.sh && \
    ./configure --prefix="$STOW_DIR/cava" && \
    make && \
    sudo make install && \
    cd "$STOW_DIR" && \
    sudo stow -R cava
popd
# }}}

# Fira Mono {{{
mkdir -p "$HOME/.local/share/fonts" && \
    pushd "$HOME/.local/share/fonts" && \
    git clone https://github.com/mozilla/Fira.git --depth 1 && \
    mv Fira/ttf/* . && \
    rm -rf Fira
popd
# }}}

# NVM {{{
NVM_DIR="$HOME/.nvm" && \
    git clone https://github.com/creationix/nvm.git "$NVM_DIR" && \
    pushd "$NVM_DIR" && \
    git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" origin)"
popd
# }}}
# }}}

# Configuration {{{
# RabbitMQ {{{
sudo rabbitmq-plugins enable rabbitmq_management
# }}}

# VSCode Inotify Watches {{{
echo 'fs.inotify.max_user_watches=524288' | sudo tee /etc/sysctl.conf
sudo sysctl -p
# }}}

# Profile Sync Daemon {{{
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" | sudo tee /etc/sudoers.d/psd
# }}}

# Redis Cluster {{{
gem install redis
pip install redis-py-cluster
pip3 install redis-py-cluster
# }}}

# Docker {{{
sudo groupadd docker
sudo usermod -aG docker "$USER"
# }}}

# MPD {{{
mkdir ~/Music/Playlists
# }}}

# Setup systemd services {{{
sudo systemctl disable rabbitmq-server mysql mpd.service mpd.socket mpdscribble mongod docker
sudo systemctl stop rabbitmq-server mysql mpd.service mpd.socket mpdscribble mongod docker

# APT File {{{
cat << 'EOF' > "$HOME/.config/systemd/user/apt-file.service"
[Unit]
Description=Weekly apt-file update

[Service]
Type=oneshot
ExecStart=/usr/bin/apt-file update
EOF

cat << 'EOF' > "$HOME/.config/systemd/user/apt-file.timer"
[Unit]
Description=Run apt-file update weekly

[Timer]
OnCalendar=weekly
RandomizedDelaySec=1h
Persistent=true
AccuracySec=1h

[Install]
WantedBy=timers.target
EOF
# }}}

# Clean Bash History {{{
cat << EOF > "$HOME/.config/systemd/user/clean-bash-history-daily.service"
[Unit]
Description=Remove duplicates and some commands from bash history

[Service]
Type=oneshot
ExecStart=$HOME/bin/cleanup_bash_hist.sh
EOF

cat << EOF > "$HOME/.config/systemd/user/clean-bash-history-daily.timer"
[Unit]
Description=Remove duplicates and some commands from bash history

[Timer]
OnCalendar=daily
RandomizedDelaySec=1h
Persistent=true
AccuracySec=1h

[Install]
WantedBy=timers.target
EOF

cat << EOF > "$HOME/.config/systemd/user/clean-bash-history.service"
[Unit]
Description=Remove duplicates and some commands from bash history
DefaultDependencies=no
Before=reboot.target shutdown.target

[Service]
Type=oneshot
ExecStart=$HOME/bin/cleanup_bash_hist.sh

[Install]
WantedBy=reboot.target shutdown.target
EOF
# }}}

# MPD and MPDScribble {{{
cat << 'EOF' > "$HOME/.config/systemd/user/mpd.service"
[Unit]
Description=Music Player Daemon

[Service]
EnvironmentFile=/etc/default/mpd
ExecStart=/usr/bin/mpd --no-daemon $MPDCONF

# allow MPD to use real-time priority 50
LimitRTPRIO=50
LimitRTTIME=infinity

# disallow writing to /usr, /bin, /sbin, ...
ProtectSystem=yes

[Install]
WantedBy=default.target
EOF

cat << EOF > "$HOME/.config/systemd/user/mpdscribble.service"
[Unit]
Description=Last.fm reporting client for mpd
Documentation=man:mpdscribble(1)

[Service]
ExecStart=/usr/bin/mpdscribble --no-daemon --conf $HOME/.config/mpdscribble/mpdscribble.conf --log $HOME/.config/mpdscribble/log

[Install]
WantedBy=default.target
EOF
# }}}

# SSH Agent {{{
cat << 'EOF' > "$HOME/.config/systemd/user/ssh-agent.service"
[Unit]
Description=SSH key agent

[Service]
Type=simple
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK

[Install]
WantedBy=default.target
EOF
# }}}

# Resilio Sync Service {{{
sudo systemctl stop resilio-sync
cat << 'EOF' > /tmp/resilio-service.patch
14c14
< WantedBy=multi-user.target
---
> WantedBy=default.target
EOF
sudo patch /usr/lib/systemd/user/resilio-sync.service /tmp/resilio-service.patch
# }}}

systemctl --user daemon-reload
systemctl --user enable mpd mpdscribble apt-file.timer clean-bash-history clean-bash-history-daily.timer ssh-agent resilio-sync
systemctl --user start mpd mpdscribble apt-file.timer clean-bash-history clean-bash-history-daily.timer ssh-agent resilio-sync
# }}}
# }}}

# Jabong Important Repos {{{
export GEM_HOME="$(ruby -e 'print Gem.user_dir')"
gem --user-install --no-document octokit
_curdir="$(pwd)"
mkdir -pv "$HOME/go/src/github.com/jabong" && \
    pushd "$HOME/go/src/github.com/jabong" && \
    ruby "${_curdir}/get-repo-list.rb" | sed -e 's/git@github.com/git@jabong.github.com/' | xargs -n1 git clone
# }}}

# vim: set fen fdm=marker sw=4 sts=4 ts=4 et:

