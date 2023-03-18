FROM ubuntu:18.04

LABEL maintainer="aleksanderhan@gmail.com"
LABEL version="1.0"
LABEL description="Docker base image for amd gpu"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && apt install -y \
    apt-utils \
    clinfo \
    curl \
    build-essential \
    dkms \
    python3-pip;

RUN mkdir -p /tmp/opencl-driver-amd
WORKDIR /tmp/opencl-driver-amd

ARG AMD_DRIVER=amdgpu-pro-20.40-1147287-ubuntu-18.04
ARG FILE_EXT=.tar.xz
ARG AMD_DRIVER_URL=https://drivers.amd.com/drivers/linux

RUN curl --referer $AMD_DRIVER_URL -O $AMD_DRIVER_URL/$AMD_DRIVER$FILE_EXT

RUN apt update -y
RUN apt install -y libc6:amd64 libstdc++6:amd64

RUN tar -Jxvf $AMD_DRIVER$FILE_EXT
RUN apt install -y mesa-opencl-icd
RUN ./$AMD_DRIVER/amdgpu-install -y --headless --opencl=pal,legacy --no-dkms

WORKDIR ~/
COPY ./requirements.txt .
COPY ./script.py .

RUN python3 -m pip install pip==21.0.1

RUN pip3 install -r ./requirements.txt

CMD ["script.py"]
ENTRYPOINT ["python3"]

