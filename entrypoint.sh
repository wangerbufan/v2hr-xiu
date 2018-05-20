if [ ! -d /v2raybin/v2ray-v$V2RAY_VER-linux-64 ]; then
  rm -rf /v2raybin
  mkdir /v2raybin
  cd /v2raybin
  wget -O v2ray.zip http://github.com/v2ray/v2ray-core/releases/download/v$V2RAY_VER/v2ray-linux-64.zip
  unzip v2ray.zip 
  cd /v2raybin/v2ray-v$V2RAY_VER-linux-64
  chmod +x v2ray
  chmod +x v2ctl
fi

if [ ! -d /caddybin/caddy_v$CADDY_VER ]; then
  rm -rf /caddybin
  mkdir /caddybin
  mkdir /caddybin/caddy_v$CADDY_VER
  cd /caddybin/caddy_v$CADDY_VER
  wget -O caddy.tar.gz https://github.com/mholt/caddy/releases/download/v$CADDY_VER/caddy_v$CADDY_VER'_linux_amd64.tar.gz'
  tar xvf caddy.tar.gz 
  chmod +x caddy
fi

if [ ! -d $CADDY_ROOT ]; then
  mkdir $CADDY_ROOT
  cd $CADDY_ROOT
  wget -O wallet.bitshares.org-gh-pages.zip https://github.com/bitshares/wallet.bitshares.org/archive/gh-pages.zip
  unzip wallet.bitshares.org-gh-pages.zip
fi

cd /v2raybin/v2ray-v$V2RAY_VER-linux-64
echo -e -n "$CONFIG_JSON1" > config.json
echo -e -n "$V2_WS_PORT,\"listen\":\"$V2_WS_IP\"" >> config.json
echo -e -n "$CONFIG_JSON2" >> config.json
echo -e -n "$UUID" >> config.json
echo -e -n "$CONFIG_JSON3" >> config.json
echo -e -n "$V2_WS_PATH" >> config.json
echo -e -n "$CONFIG_JSON4" >> config.json
./v2ray &

cd /caddybin/caddy_v$CADDY_VER
echo $CADDY_LS_IP:$PORT { > HerokuCaddyfile
echo root $CADDY_ROOT/wallet.bitshares.org-gh-pages >> HerokuCaddyfile
echo gzip >> HerokuCaddyfile
echo index $CADDY_INDEX >> HerokuCaddyfile
echo forwardproxy { >> HerokuCaddyfile
echo basicauth h2User testPWD >> HerokuCaddyfile
echo } >> HerokuCaddyfile
echo proxy $V2_WS_PATH $V2_WS_IP:$V2_WS_PORT { >> HerokuCaddyfile
echo websocket >> HerokuCaddyfile
echo } >> HerokuCaddyfile
echo } >> HerokuCaddyfile
./caddy -conf="HerokuCaddyfile"
