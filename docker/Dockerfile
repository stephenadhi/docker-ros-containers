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

# Setup for installing ros
RUN apt update -y && sudo apt -y install locales
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && export LANG=en_US.UTF-8
RUN apt install -y software-properties-common && add-apt-repository universe
RUN apt update -y && apt install -y curl gnupg lsb-release && rm -rf /var/lib/apt/lists/*

# setup sources.list
RUN echo "deb http://packages.ros.org/ros2/ubuntu jammy main" > /etc/apt/sources.list.d/ros2-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO humble

# install ros2 packages
RUN apt-get update -y && apt-get install -y ros-humble-desktop-full && rm -rf /var/lib/apt/lists/*
RUN apt update -y && apt install -y python3-pip python3-rosdep2 && pip3 install colcon-common-extensions vcstool

# Set-up auto-source of workspace for user  
ADD src/ ${WORKSPACE}/src
RUN echo "if [ -f ${WORKSPACE}/install/setup.bash ]; then source ${WORKSPACE}/install/setup.bash; fi" >> ~/.bashrc

# auto install workspace dependencies
RUN rosdep update
RUN rosdep install -i -y -r --from-paths ${WORKSPACE}/src --rosdistro humble

# auto install pip dependencies
COPY requirements.txt ${WORKSPACE}/requirements.txt
RUN pip3 install -r ${WORKSPACE}/requirements.txt

# add gazebo models and source gazebo installation
RUn mkdir -p /root/.gazebo/models && git clone https://github.com/stephenadhi/gazebo_models.git /root/.gazebo/models
RUN echo "source /usr/share/gazebo/setup.sh" >> ~/.bashrc   

# setup entrypoint
COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["bash"]