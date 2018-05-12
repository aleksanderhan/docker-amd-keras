FROM ubuntu:16.04

WORKDIR /tmp/

COPY ./requirements-amd.txt .
ADD ./amdgpu-pro-17.40-492261.tar.xz .

RUN apt-get -qq update && \
    apt-get -qq install --assume-yes \
    	git \
    	pciutils \
    	#apt-utils\
    	wget \
        build-essential \                     
        cmake \
        libboost-all-dev \
        python3 \
        python3-wheel \
        python3-dev \
        python3-h5py \
        python3-yaml \
        python3-pydot \
        python3-setuptools \
        python3-pip #&& \
    #apt-get clean && \
    #rm -rf /var/lib/apt/lists/*

#RUN wget --referer=https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-16.40-348864.tar.xz \
#	https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-16.40-348864.tar.xz

	
RUN tar -Jxvf amdgpu-pro-17.40-492261.tar.xz && \
	#dpkg --add-architecture i386 && \
	./amdgpu-pro-17.40-492261/amdgpu-pro-install -y

RUN wget -qO - http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | apt-key add - && \
	sh -c 'echo deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main > /etc/apt/sources.list.d/rocm.list'

RUN mkdir /etc/udev/rules.d && \
	apt-get -qq update && \
	apt-get -qq install --assume-yes --no-install-recommends \
		libnuma-dev \
		rocm-dkms \
		rocm-opencl-dev

#RUN pip3 --no-cache-dir install -r ./requirements-amd.txt
