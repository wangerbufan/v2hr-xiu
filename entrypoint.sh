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

cd /caddybin/caddy_v$CADDY_VER
echo $CADDY_LS_IP:$PORT { > HerokuCaddyfile
echo root $CADDY_ROOT/wallet.bitshares.org-gh-pages >> HerokuCaddyfile
echo gzip >> HerokuCaddyfile
echo index $CADDY_INDEX >> HerokuCaddyfile
echo forwardproxy { >> HerokuCaddyfile
echo basicauth $CADDY_USER $CADDY_PASS >> HerokuCaddyfile
echo } >> HerokuCaddyfile
echo } >> HerokuCaddyfile
./caddy -conf="HerokuCaddyfile"
