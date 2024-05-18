FROM ros:humble

RUN apt update && apt install -y --no-install-recommends gnupg

RUN apt update && apt -y upgrade

RUN apt update && apt install -y --no-install-recommends \
        meson \
	ninja-build \
	pkg-config \
	libyaml-dev \
	python3-yaml \
	python3-ply \
	python3-jinja2 \
	libevent-dev \
	libdrm-dev \
	libcap-dev \
	python3-pip \
	python3-opencv \
     && apt-get clean \
     && apt-get autoremove \
     && rm -rf /var/cache/apt/archives/* \
     && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install libcamera from source
RUN git clone https://github.com/raspberrypi/libcamera.git
RUN meson setup libcamera/build libcamera/
RUN ninja -C libcamera/build/ install


# Install kmsxx from source
RUN git clone https://github.com/tomba/kmsxx.git
RUN meson setup kmsxx/build kmsxx/
RUN ninja -C kmsxx/build/ install 

# Add the new installations to the python path so that picamera2 can find them
ENV PYTHONPATH $PYTHONPATH/usr/local/lib/aarch64-linux-gnu/python3.10/site-packages:/app/kmsxx/build/py

# Finally install picamera2 using pip
RUN pip3 install picamera2

# Copy the test script to the container
COPY camera_test /app/camera_test

# Set the entry point. You can comment this out to use your own test scripts...
CMD ["python3", "/app/camera_test/main.py"]