FROM althack/ros2:foxy-dev
ENV WORKSPACE=/home/workspace/ros_foxy
ENV ROS_DISTRO=foxy
RUN mkdir -p ${WORKSPACE}

# Add folders for publishers of kml and obstacles
RUN mkdir -p /home/dst/kml_path
RUN mkdir -p /home/dst/kml_obstacles

# add deb-src to sources list for installing qt5 build for xserver
RUN apt-get update -y
RUN cp /etc/apt/sources.list /etc/apt/sources.list~
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# xserver
RUN apt-get update -y
RUN apt-get build-dep qt5-default -y
RUN ldd /usr/lib/x86_64-linux-gnu/qt5/plugins/platforms/libqxcb.so
RUN apt-get install -y '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev 
RUN apt-get install -y libxcb-util-dev

# fix corrupted qt5 installation after installing x server
RUN apt-get --reinstall install -y libqt5svg5

# Set-up auto-source of workspace for user 
WORKDIR ${WORKSPACE}
ADD src/ ${WORKSPACE}/src
RUN echo "if [ -f ${WORKSPACE}/install/setup.bash ]; then source ${WORKSPACE}/install/setup.bash; fi" >> ~/.bashrc

# setup rosdep; do not run rosdep install with sudp
RUN apt-get update --fix-missing -y 
RUN apt-get install -y --no-install-recommends python3-rosdep2 python3-colcon-common-extensions
RUN rosdep update
RUN rosdep install -i -y --from-paths ${WORKSPACE}/src --rosdistro foxy
RUN colcon build

COPY requirements.txt ${WORKSPACE}/requirements.txt
RUN pip install -r ${WORKSPACE}/requirements.txt

# add gazebo models and source gazebo installation
RUN mkdir -p /root/.gazebo/models && git clone https://github.com/stephenadhi/gazebo_models.git /root/.gazebo/models
RUN echo "source /usr/share/gazebo/setup.sh" >> ~/.bashrc   

# setup entrypoint
COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["bash"]