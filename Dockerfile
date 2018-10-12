### STAGE 1: Build NEST ###
FROM ubuntu:18.04 as nest-builder
LABEL maintainer="Sebastian Spreizer <spreizer@web.de>"

RUN apt update && apt install -y \
    build-essential \
    cmake \
    cython3 \
    git \
    libgsl0-dev \
    libltdl7-dev \
    libncurses5-dev \
    libreadline6-dev \
    python3-all-dev \
    python3-numpy

WORKDIR /tmp
RUN git clone https://github.com/compneuronmbu/nest-simulator.git && \
    cd /tmp/nest-simulator && \
    git fetch && \
    git checkout nest-3 && \
    git checkout 4348e5 && \
    mkdir /tmp/nest-build

WORKDIR /tmp/nest-build
RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest/ -Dwith-python=3 /tmp/nest-simulator && \
    make && \
    make install && \
    rm -rf /tmp/*


### STAGE 2: Build NEST Desktop ###
FROM ubuntu:18.04 as nest-desktop-builder
LABEL maintainer="Sebastian Spreizer <spreizer@web.de>"

RUN apt update && apt install -y \
    build-essential \
    curl

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt update && apt install -y nodejs

COPY . ./opt/nest-desktop
WORKDIR /opt/nest-desktop
RUN npm i && \
    npm run build


### STAGE 3: Setup ###
FROM ubuntu:18.04
LABEL maintainer="Sebastian Spreizer <spreizer@web.de>"

RUN apt update && apt install -y \
    git \
    libgsl0-dev \
    libltdl7-dev \
    nginx \
    python3-pip \
    python3-numpy

RUN pip3 install flask==0.12.4 flask-cors && \
    git clone https://github.com/babsey/nest-server /opt/nest-server && \
    rm -rf /var/www/html/*

COPY --from=nest-builder /opt/nest /opt/nest
COPY --from=nest-desktop-builder /opt/nest-desktop/dist/nest-desktop /var/www/html

WORKDIR /root
EXPOSE 80 5000

COPY entrypoint.sh .
RUN chmod 755 entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
