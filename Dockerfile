FROM amd64/ubuntu:latest

# Get env variable from host.
ARG _APPLET_PRIVATE_KEY

# Install dependencies.
RUN apt-get update && apt-get install -y make
RUN apt-get install -y signify-openbsd
RUN apt-get install -y wget
RUN wget https://github.com/usbarmory/tamago-go/releases/download/tamago-go1.20.4/tamago-go1.20.4.linux-amd64.tar.gz
RUN tar -xvf tamago-go1.20.4.linux-amd64.tar.gz -C /

WORKDIR /build

COPY . .

ENV TAMAGO=/usr/local/tamago-go/bin/go
# RUN /bin/signify-openbsd -G -n -p armored-witness-applet.pub -s armored-witness-applet.sec
RUN echo 'untrusted comment: signify secret key' > armored-witness-applet.sec
RUN echo $_APPLET_PRIVATE_KEY >> armored-witness-applet.sec
ENV APPLET_PRIVATE_KEY=armored-witness-applet.sec

RUN make trusted_applet

