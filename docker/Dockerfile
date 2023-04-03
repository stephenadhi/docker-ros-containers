# install NVDIA CUDA/CUDNN on Ubuntu 22.04 environment
FROM nvcr.io/nvidia/l4t-jetpack:r35.2.1

ENV DEBIAN_FRONTEND="noninteractive"
ENV QT_X11_NO_MITSHM=1
ENV WORKSPACE="/workspaces/locobot" 

RUN apt-get update -y && apt-get install -y --no-install-recommends \
        ca-certificates \
        devilspie \
        gnupg2 \
        mesa-utils \
        unzip \
        wget \
        xfce4-terminal \
        git \
        nano

# add deb-src to sources list for installing qt5 build for xserver
RUN apt-get update -y
RUN cp /etc/apt/sources.list /etc/apt/sources.list~
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# Setup for installing ros
RUN apt update -y && apt -y install locales
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && export LANG=en_US.UTF-8
RUN apt install -y software-properties-common && add-apt-repository universe
RUN apt update -y && apt install -y curl gnupg lsb-release && rm -rf /var/lib/apt/lists/*
RUN apt update -y && apt install -y \
    python3-flake8-docstrings \
    python3-pip \
    python3-pytest-cov \
    ros-dev-tools
RUN python3 -m pip install -U \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-import-order \
    flake8-quotes \
    pytest-repeat \
    pytest-rerunfailures

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO humble

# install ros2 packages
RUN apt-get update -y && apt install curl && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN apt update -y && apt install -y python3-pip python3-rosdep2 && pip3 install colcon-common-extensions vcstool
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release \
    && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN mkdir -p ${WORKSPACE}/src && cd ~/ros2_humble && vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src && apt upgrade -y 

# Set-up auto-source of workspace for user  
RUN echo "if [ -f ${WORKSPACE}/install/setup.bash ]; then source ${WORKSPACE}/install/setup.bash; fi" >> ~/.bashrc

# auto install workspace dependencies
RUN rosdep init && rosdep update
RUN rosdep install -i -y -r --from-paths ${WORKSPACE}/src --rosdistro humble
RUN cd ${WORKSPACE} && colcon build --symlink-install

# auto install pip dependencies
COPY requirements.txt ${WORKSPACE}/requirements.txt
RUN pip3 install -r ${WORKSPACE}/requirements.txt

# add gazebo models and source gazebo installation
RUN mkdir -p /root/.gazebo/models && git clone https://github.com/stephenadhi/gazebo_models.git /root/.gazebo/models
RUN echo "source /usr/share/gazebo/setup.sh" >> ~/.bashrc   

# setup entrypoint
COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["bash"]