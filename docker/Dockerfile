# install NVDIA CUDA/CUDNN on Ubuntu 22.04 environment
FROM nvcr.io/nvidia/isaac/ros:aarch64-ros2_humble_33836e394da2d095a59afd2d151038f8

ENV JETPACK_MAJOR=5
ENV JETPACK_MINOR=1
ENV L4T_MAJOR=35
ENV L4T_MINOR=2
ENV ZED_SDK_MAJOR=4
ENV ZED_SDK_MINOR=0
ENV DEBIAN_FRONTEND="noninteractive"
ENV QT_X11_NO_MITSHM=1
ENV WORKSPACE="/workspaces/humble"

#Install ZED SDK
RUN echo "*** Installing ZED SDK v${ZED_SDK_MAJOR}.${ZED_SDK_MINOR} for Jetpack ${JETPACK_MAJOR}.${JETPACK_MINOR} (L4T v${L4T_MAJOR}.${L4T_MINOR})"
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 42D5A192B819C5DA
RUN apt-get update -y || true
RUN apt-get install -y --no-install-recommends zstd wget less cmake curl gnupg2 \
    build-essential python3 python3-pip python3-dev python3-setuptools libusb-1.0-0-dev -y && \
    pip install protobuf && \
    wget -q --no-check-certificate -O ZED_SDK_Linux_JP.run \
    https://download.stereolabs.com/zedsdk/${ZED_SDK_MAJOR}.${ZED_SDK_MINOR}/l4t${L4T_MAJOR}.${L4T_MINOR}/jetsons && \
    chmod +x ZED_SDK_Linux_JP.run ; ./ZED_SDK_Linux_JP.run silent skip_tools && \
    rm -rf /usr/local/zed/resources/* && \
    rm -rf ZED_SDK_Linux_JP.run && \
    rm -rf /var/lib/apt/lists/* 
RUN mkdir -p /home/zedbox && cd /home/zedbox && source /opt/ros/humble/install/setup.bash && \ 
    wget https://raw.githubusercontent.com/stereolabs/zed-ros2-wrapper/master/.ci/jetson_build_humble_src.sh && \ 
    chmod +x jetson_build_humble_src.sh && ./jetson_build_humble_src.sh

# setup entrypoint
COPY ./ros_entrypoint.sh /
RUN bash -c "chmod +x /ros_entrypoint.sh"
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["bash"]
