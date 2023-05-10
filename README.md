## Using Docker Container with VSCode for ROS / ROS 2 Development
This repository provides you with a Dockerfile for building a ROS development environment and the .devcontainer folder for VSCode configuration. Use these files as a starting point for your own ROS development projects. Docker containers simplify setting up and managing development environments across different machines and operating systems, and with the VSCode integration, you can take advantage of many of its features like debugging and integrated terminal while working in a containerized environment.

### Prerequisites
You need to have the following installed on your machine:

- Docker Desktop (https://www.docker.com/products/docker-desktop)
- Visual Studio Code (https://code.visualstudio.com/)
- Remote Development extension for VSCode (https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

### Usage

Clone this repository to your local machine.

    git clone https://github.com/stephenadhi/docker-ros-containers.git

1. Open the cloned repository folder inside VSCode.

2. Install the Remote Development and Docker extensions for VSCode.

3. In VSCode, open the Command Palette by pressing Ctrl+Shift+P. 
4. Select the Remote-Containers: Open Folder in Container... option from the Command Palette.

5. Wait for the container to build. The container will be started automatically inside VSCode.
6. You can now start developing your ROS applications inside the container.

### Contents

**Dockerfile**: This folder contains the Dockerfiles 

**.devcontainer**: This folder contains the configuration files and settings necessary to build and run the Docker container inside VSCode. It includes the devcontainer.json and docker-compose.yml files.

**requirements.txt**: Python libraries to be installed by pip install.

**src**: This folder should contain your ROS packages you want to develop.