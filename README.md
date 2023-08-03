## Using Docker Container with VSCode for ROS / ROS 2 Development
This repository provides you with a Dockerfile for building a ROS development environment and the .devcontainer folder for VSCode configuration. Use these files as a starting point for your own ROS development projects. Docker containers simplify setting up and managing development environments across different machines and operating systems, and with the VSCode integration, you can take advantage of many of its features like debugging and integrated terminal while working in a containerized environment. 

### Prerequisites
The purpose of a docker container is to make easier collaboration in development, management of dependencies, and cleaner deployment, ensuring the repeatability and reliability of applications.
You need to have the following installed on your machine:

- Linux PC with CUDA available
- Docker Desktop (https://www.docker.com/products/docker-desktop)
- Visual Studio Code (https://code.visualstudio.com/)
- Remote Development extension for VSCode (https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

### Folder Structure

    [project]_ws
    ├── .devcontainer
    │   ├── devcontainer.json    : configuration file for running docker container, such as folder mounting, port sharing, network, etc.
    │   ├── docker-compose.yml   : For defining multi-container Docker applications
    ├── docker
    │   └── Dockerfile1          : Custom dockerfile image1
    │   └── Dockerfile2          : Custom dockerfile image2
    ├── src
        ├── ros_package1
        ├── ros_package2
    |── requirements.txt         : Put python3 package dependencies inside this file

### Contents

**docker**: This folder contains the Dockerfiles

**.devcontainer**: This folder contains the configuration files and settings necessary to build and run the Docker container inside VSCode. It includes the devcontainer.json and docker-compose.yml files.

**requirements.txt**: Python libraries to be installed by pip3 install.

**src**: This folder should contain the ROS packages you want to develop.

### Usage

Clone this repository to your local machine. Put your ROS packages inside src folder!

    git clone https://github.com/stephenadhi/docker-ros-containers.git

1. Open the cloned repository folder inside VSCode.

2. Install the Remote Development and Docker extensions for VSCode.

3. In VSCode, open the Command Palette by pressing Ctrl+Shift+P. 
4. Select the Remote-Containers: Open Folder in Container... option from the Command Palette.

5. Wait for the container to build. The container will be started automatically inside VSCode.
6. You can now start developing your ROS applications inside the container.

### Using GUIs with Docker
It is possible to view GUI applications such as Gazebo and RViZ inside a docker container by using X server. The simplest way is to give access to the Xserver in our host terminal. However, it is not the most secure way due to compromising access control to X server on your host. 

    xhost +local:root # for the lazy and reckless

For further information on giving access the safer way, see the documentation  at http://wiki.ros.org/docker/Tutorials/GUI


### Further Notes 

- Continuous updates of the Dockerfile would be needed for dependencies
- If conflict: separate Dockerfiles (i.e. object segmentation openCV 4.2, inference openCV 4.5)
- Run multiple Dockerfiles at the same time using Docker compose # TODO: @Stephen
- Both Development and Deployment using docker-compose.yml
- For deployment: Different base images for ARM architecture i.e. for Jetson 
