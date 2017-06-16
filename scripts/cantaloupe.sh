#!/bin/bash
echo "Installing Cantaloupe IIIF Image Server"

HOME_DIR=$1

if [ -f "$HOME_DIR/islandora/configs/variables" ]; then
  . "$HOME_DIR"/islandora/configs/variables
fi

if [ ! -f "$DOWNLOAD_DIR/Cantaloupe-${CANTALOUPE_VERSION}.zip" ]; then
  echo "Downloading Cantaloupe version ${CANTALOUPE_VERSION}"
  wget -q -O "$DOWNLOAD_DIR/Cantaloupe-${CANTALOUPE_VERSION}.zip" "https://github.com/medusa-project/cantaloupe/releases/download/v${CANTALOUPE_VERSION}/Cantaloupe-${CANTALOUPE_VERSION}.zip"
fi

if [ ! -f "$DOWNLOAD_DIR/openjpeg-v${OPENJPEG_VERSION}-linux-x86_64.tar.gz" ]; then
  echo "Downloading OpenJPEG ${OPENJPEG_VERSION}"
  wget -q -O "$DOWNLOAD_DIR/openjpeg-v${OPENJPEG_VERSION}-linux-x86_64.tar.gz" "https://github.com/uclouvain/openjpeg/releases/download/v${OPENJPEG_VERSION}/openjpeg-v${OPENJPEG_VERSION}-linux-x86_64.tar.gz"
fi

#apt-get -y -qq install liblcms2-dev
#apt-get -y -qq install libpng-dev
#apt-get -y -qq install libtiff-dev
#apt-get -y -qq install cmake

tar xf "$DOWNLOAD_DIR/openjpeg-v${OPENJPEG_VERSION}-linux-x86_64.tar.gz" -C /opt
mv "/opt/openjpeg-v${OPENJPEG_VERSION}-linux-x86_64" /opt/openjpeg
#tar -xvzf "$DOWNLOAD_DIR/openjpeg-source.tar.gz" -C /tmp 
#mkdir "/tmp/openjpeg-2.1.2/build"
#cd "/tmp/openjpeg-2.1.2/build"
#cmake ..
#make
#make install
#ldconfig

mkdir /opt/cantaloupe
mkdir /opt/cantaloupe/images
mkdir /var/log/cantaloupe
unzip "$DOWNLOAD_DIR/Cantaloupe-${CANTALOUPE_VERSION}.zip" -d /opt/cantaloupe
cp "$HOME_DIR/islandora/configs/cantaloupe/cantaloupe.properties" "/opt/cantaloupe/cantaloupe.properties"
echo 'CATALINA_OPTS="${CATALINA_OPTS} -Dcantaloupe.config=/opt/cantaloupe/cantaloupe.properties -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true"' >> /etc/default/tomcat8
chown -R tomcat8:tomcat8 /opt/cantaloupe
chown -R tomcat8:tomcat8 /var/log/cantaloupe
service tomcat8 restart
mv /opt/cantaloupe/Cantaloupe-${CANTALOUPE_VERSION}/Cantaloupe-${CANTALOUPE_VERSION}.war /var/lib/tomcat8/webapps/cantaloupe.war
