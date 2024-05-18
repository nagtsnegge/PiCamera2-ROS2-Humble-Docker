# PiCamera2 ROS2 Docker Integration

This repository provides an example of how to integrate the original Raspberry Pi camera with a **Raspberry Pi 5** using a Docker container running ROS2 "Humble". The `picamera2` library, which is primarily developed for Raspberry Pi OS, neends some additional dependencies to work properly within a Docker container based on the ROS2 `ros:humble` image (which is based on Ubuntu 22.04).


## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Usage](#usage)
- [Dockerfile Explanation](#dockerfile-explanation)
- [License](#license)

## Introduction
The goal of this repository is to provide a simple and functional example for using the Raspberry Pi camera within a Docker container running ROS2 `ros:humble`. This can be particularly useful for those who want to develop ROS2 applications that interact with the Raspberry Pi camera.

To test the camera in the container, I use a simple Python script from [hyzhak's pi-camera-in-docker](https://github.com/hyzhak/pi-camera-in-docker). Hyzhak provides an example of how to stream from a Raspberry Pi camera wrapped in a Debian container. 

You can find the original script [here](https://github.com/hyzhak/pi-camera-in-docker/blob/main/pi_camera_in_docker/main.py), but it's mostly copied from the [picamera documentaion](https://picamera.readthedocs.io/en/release-1.13/recipes2.html).

## Prerequisites
- Raspberry Pi 5
- Raspberry Pi Camera
- Docker installed on your Raspberry Pi
- Test the camera on your Raspberry Pi before running the Docker container to ensure it is working properly. (For example, you can run `rpicam-hello` to test the camera.)

## Setup
1. Clone this repository:
    ```sh
    git clone https://github.com/nagtsnegge/PiCamera2-ROS2-Humble-Docker.git
    cd PiCamera2-ROS2-Humble-Docker
    ```

2. Build the Docker image:
    ```sh
    docker build -t ros2-picamera2-demo .
    ```

## Usage
To work properly, the Docker container must be run with the `--privileged` flag. Besides that, you have to pass the `/run/udev` directory to the container. This directory manages the device nodes in `/dev`. The container must have access to this directory to create the necessary device nodes for the Raspberry Pi camera.

Follow the steps below to run the Docker container and the test script:
1. Run the Docker container:
    ```sh
    docker run --privileged -v /run/udev:/run/udev -p 8000:8000 ros2-picamera2-demo
    ```
2. Open the follwing URL in your browser to view the video stream:
    ```
    http://localhost:8000
    ```

## Dockerfile Explanation
The provided Dockerfile performs the following steps:
1. **Base Image**: Uses the `ros:humble` image as the base image. This image is based on Ubuntu 22.04 and contains the ROS2 "Humble" distribution.
2. **Install Dependencies**: Installs necessary packages and cleans up to reduce the image size.
3. **Build and Install `libcamera`**: Clones, builds, and installs the libcamera library from the official repository. libcamera is a library that provides support for camera devices in Linux-based systems.
4. **Build and Install `kmsxx`**: Clones, builds, and installs the kmsxx library from GitHub. kmsxx is a C++ library that provides a simple API to interact with the Linux Kernel Mode Setting (KMS) API.
5. **Set Python Path**: Adds the new installations to the Python path.
6. **Install `picamera2`**: Installs the picamera2 library via `pip`.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
