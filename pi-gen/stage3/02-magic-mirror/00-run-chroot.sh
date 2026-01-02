#cd ~
#git clone https://github.com/MichMich/MagicMirror
#cd MagicMirror/
#npm run install-mm
#cp config/config.js.sample config/config.js
ls -lrt /home/
cat /etc/passwd
mkdir /home/pi/bin
chown pi:pi /home/pi/bin
cat <<EOT > /home/pi/bin/start-chromium.sh
#!/bin/sh

set -e

CHROMIUM_TEMP=/tmp/chromium
rm -Rf /home/pi/.config/chromium/
rm -Rf \$CHROMIUM_TEMP
mkdir -p \$CHROMIUM_TEMP

chromium-browser \
        --disable \
        --disable-translate \
        --disable-infobars \
        --disable-suggestions-service \
        --disable-save-password-bubble \
        --disk-cache-dir=\$CHROMIUM_TEMP/cache/ \
        --user-data-dir=\$CHROMIUM_TEMP/user_data/ \
	--use-gl=egl \
	--disable-webgl \
	--enable-accelerated-2d-canvas \
	--enable-auto-reload \
	--disable-component-update \
	--disable-web-security \
	--disable-features=Widevine \
	--aggressive-cache-discard \
	--disable-mipmap-generation
        --start-maximized \
        --kiosk http://$host:$port &
EOT

#ls -lrt /home/pi/.config
#ls -lrt /home/pi/.config/lxsession/
mkdir -p /home/pi/.config/lxsession/LXDE-pi
chown -R pi:pi /home/pi/.config
cat <<EOT > /home/pi/.config/lxsession/LXDE-pi/autostart
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
@xscreensaver -no-splash
@point-rpi
@sh /home/pi/bin/start-chromium.sh
EOT

mkdir -pv /etc/systemd/system/getty@tty1.service.d
#mkdir /etc/this_is_a_test

cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin pi --noclear %I \$TERM
EOF

echo "[[ -z \$DISPLAY && \$XDG_VTNR -eq 1 ]] && exec startx" >> /home/pi/.profile
