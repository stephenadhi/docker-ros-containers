# install NVDIA CUDA/CUDNN on Ubuntu 22.04 environment
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND="noninteractive"
ENV QT_X11_NO_MITSHM=1
ENV WORKSPACE="/workspaces/locobot" 

RUN apt-get update -y && apt-get install -y --no-install-recommends \
        ca-certificates \
        devilspie \
        gnupg2 \
        mesa-utils \
        sudo \
        unzip \
        wget \
        xfce4-terminal \
        git \
        nano

# add deb-src to sources list for installing qt5 build for xserver
RUN apt-get update -y
RUN cp /etc/apt/sources.list /etc/apt/sources.list~
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# xserver
RUN apt-get update -y && apt-get install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools
RUN ldd /usr/lib/x86_64-linux-gnu/qt5/plugins/platforms/libqxcb.so
RUN apt-get install -y '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-util-dev

# fix corrupted qt5 installation after installing x server
RUN apt-get --reinstall install -y libqt5svg5

# Installing ROS2 HUMBLE from source
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl gnupg lsb-release &&\
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
        -o /usr/share/keyrings/ros-archive-keyring.gpg &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu jammy main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null &&\
    DEBIAN_FRONTEND=noninteractive apt-get update -y &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential \
      cmake \
      git \
      python3-flake8 \
      python3-flake8-blind-except \
      python3-flake8-builtins \
      python3-flake8-class-newline \
      python3-flake8-comprehensions \
      python3-flake8-deprecated \
      python3-flake8-docstrings \
      python3-flake8-import-order \
      python3-flake8-quotes \
      python3-pip \
      python3-pytest \
      python3-pytest-cov \
      python3-pytest-repeat \
      python3-pytest-rerunfailures \
      python3-rosdep2 \
      python3-setuptools \
      locales \
      wget

RUN python3 -m pip install -U colcon-common-extensions vcstool

RUN locale-gen en_US en_US.UTF-8 &&\
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

RUN mkdir -p /ros2_humble/src
WORKDIR /ros2_humble
RUN wget https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos
RUN vcs import src < ros2.repos
RUN rosdep update
RUN rosdep install --from-paths src --ignore-src -y --rosdistro humble \
      --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"
RUN colcon build --symlink-install

RUN rm /etc/apt/sources.list.d/ros2.list &&\
    DEBIAN_FRONTEND=noninteractive apt-get update -y &&\
    DEBIAN_FRONTEND=noninteractive apt remove -y \
        python3-catkin-pkg python3-catkin-pkg-modules &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ros-core-dev

RUN mkdir -p /ros1_bridge/src
WORKDIR /ros1_bridge
RUN git clone https://github.com/ros2/ros1_bridge
RUN /bin/bash -c ". /ros2_humble/install/local_setup.bash &&\
                  colcon build"

# Install and source vision_opencv
RUN mkdir -p /vision_opencv/src
WORKDIR /vision_opencv
RUN git clone -b humble https://github.com/ros-perception/vision_opencv.git
RUN apt install -y libboost-python-dev
RUN /bin/bash -c ". /ros2_humble/install/local_setup.bash &&\ 
                  rosdep install --from-paths src --ignore-src -y --rosdistro humble &&\ 
                  colcon build --symlink-install"

# Install and source gazebo installation 
RUN sudo apt update -y && curl -sSL http://get.gazebosim.org | sh && mkdir -p /gazebo_ros_pkgs/src
WORKDIR /gazebo_ros_pkgs
RUN git clone -b ros2 https://github.com/ros-simulation/gazebo_ros_pkgs
RUN /bin/bash -c ". /ros2_humble/install/local_setup.bash && . /vision_opencv/install/local_setup.bash &&\ 
                  rosdep install --from-paths src --ignore-src -y --rosdistro humble &&\ 
                  colcon build --symlink-install &&\
                  . /gazebo_ros_pkgs/install/local_setup.bash"

# Set-up auto-source of workspace for user  
ADD src/ ${WORKSPACE}/src
RUN echo "if [ -f ${WORKSPACE}/install/setup.bash ]; then source ${WORKSPACE}/install/setup.bash; fi" >> ~/.bashrc

# auto install workspace dependencies
RUN rosdep install -i -y -r --from-paths ${WORKSPACE}/src --rosdistro humble

# auto install pip dependencies
COPY requirements.txt ${WORKSPACE}/requirements.txt
RUN pip3 install -r ${WORKSPACE}/requirements.txt

WORKDIR /
ENV ROS1_DISTRO=noetic
ENV ROS2_DISTRO=humble
COPY ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]