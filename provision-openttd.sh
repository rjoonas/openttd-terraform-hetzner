# !/bin/bash
set +eu

export OPENTTD_VERSION=1.9.3

# -----------------------------------------------------------------------------
# 1: INSTALL DEPENDENCIES
# -----------------------------------------------------------------------------

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get upgrade -qq -y

# openttd-data & openttd-opengfx: required to run openttd
# other packages: required to clone and compile openttd
apt install -qq -y -\
  build-essential \
  git \
  liblzo2-dev \
  liblzma-dev \
  libsdl1.2-dev \
  openttd-data \
  openttd-opengfx \
  zlib1g-dev

adduser --disabled-password --gecos "" openttd

# -----------------------------------------------------------------------------
# 2: COMPILE OPENTTD
# -----------------------------------------------------------------------------

export REPO_DIR="/home/openttd/openttd-$OPENTTD_VERSION-sources"

su openttd -c \
  "git clone -b $OPENTTD_VERSION --depth 1 --quiet https://github.com/OpenTTD/OpenTTD.git $REPO_DIR &&\
  cd $REPO_DIR && \
  ./configure --enable-dedicated && \
  make"

cd $REPO_DIR
make install
ln -s /usr/local/games/openttd /usr/local/bin/openttd

su openttd -c \
  'mkdir /home/openttd/.openttd && \
  ln -s /usr/share/games/openttd/baseset /home/openttd/.openttd/baseset'

# -----------------------------------------------------------------------------
# 3: MAKE OPENTTD SYSTEMD SERVICE RUN ON SERVER STARTUP
# -----------------------------------------------------------------------------

systemctl enable openttd
