#!/bin/sh

mkdir /tmp/app
wget -O /tmp/app/trojan-go.zip https://github.com/p4gefau1t/trojan-go/releases/latest/download/trojan-go-linux-amd64.zip
unzip /tmp/app/trojan-go.zip -d /tmp/app
install -d /usr/local/share/trojan-go
mv /tmp/app/geoip.dat /tmp/app/geosite.dat /usr/local/share/trojan-go
install -m 0755 /tmp/app/trojan-go /usr/local/bin/trojan-go
rm -r /tmp/app
install -d /usr/local/etc/trojan-go

cat << EOF > /usr/local/etc/trojan-go/config.json
{
  "run_type": "server",
  "local_addr": "0.0.0.0",
  "local_port": 10000,
  "remote_addr": "yahoo.com",
  "remote_port": 80,
  "log_level": 5,
  "password": ["$UUID"],
  "tcp": {
    "no_delay": true,
    "keep_alive": true,
    "prefer_ipv4": false
  },
  "router": {
    "enabled": true,
    "block": ["geoip:private"],
    "geoip": "/usr/local/share/trojan-go/geoip.dat",
    "geosite": "/usr/local/share/trojan-go/geosite.dat"
  },
  "websocket": {
    "enabled": true,
    "path": "/$UUID",
    "host": ""
  },
  "transport_plugin": {
    "enabled": true,
    "type": "plaintext"
  }
}
EOF

/usr/local/bin/trojan-go -config /usr/local/etc/trojan-go/config.json
