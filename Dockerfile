FROM ubuntu:20.04

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libspooles-dev \
    libarpack2-dev \
    gfortran \
    wget \
    make \
    x11-apps \
    libgl1-mesa-glx

RUN apt-get install -y bzip2

WORKDIR /tmp
RUN wget http://www.dhondt.de/cgx_2.21.all.tar.bz2
RUN bunzip2 cgx_2.21.all.tar.bz2
RUN tar -xvf cgx_2.21.all.tar

WORKDIR /tmp/CalculiX/cgx_2.21/src 

RUN apt-get update && apt-get install -y \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libxmu-headers \
    libxi-dev \
    libxmu-dev \
    libxt-dev \
    libsm-dev \
    libice-dev

RUN ln -s /usr/lib/x86_64-linux-gnu/libGL.so /usr/lib64/libGL.so
RUN ln -s /usr/lib/x86_64-linux-gnu/libGLU.so /usr/lib64/libGLU.so

RUN make

RUN mv cgx /usr/bin/cgx

CMD ["/bin/bash"]
