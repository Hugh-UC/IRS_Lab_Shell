# IRS_Lab_Shell
Dockerfiles and build scripts for the IRS lab shell. This repository contains the environment configurations needed to run a development shell extension for Industrial Robots &amp; Systems lab, built on ROS 2 Humble.

***

## Install Lab Shell | Docker for Industrial Robots and Systems

Welcome to the Industrial Robots and Systems Lab Shell repository! This provides a pre-configured Docker environment for developing ROS 2 projects. The provided scripts automatically configure your local environment to work with the main lab's `industrial-robots-and-systems-world` repository.

<br>

## Getting Started

### 1. Clone the Repositories

First, you need to clone both the main lab repository and this repository. You should clone them into your user's home directory (`~`).


Clone the '[Collaborative Robotics Lab](https://github.com/CollaborativeRoboticsLab/industrial-robots-and-systems-world.git)' lab repository
```sh
git clone https://github.com/CollaborativeRoboticsLab/industrial-robots-and-systems-world.git ~/industrial-robots-and-systems-world
```

Clone your group repository
```sh
# replace <group_number> with your group's number (i.e. 07)
git clone https://github.com/Hugh-UC/IRS_2025_<groups_number>.git ~/IRS_2025_01
```

Clone [this repository](https://github.com/Hugh-UC/IRS_Lab_Sell.git)
```sh
git clone https://github.com/Hugh-UC/IRS_Lab_Shell.git ~/IRS_Lab_Shell
```

<br>

### 2. Run the Setup Script

The `setup_override.sh` script automates the Docker Compose configuration. Navigate to the `scripts` directory and run the script. It will prompt you for the path to the main lab repository and then configure the volume mounts.

Enter this repositories scripts folder
```sh
cd ~/IRS_Lab_Shell/scripts
```

Allow permissions to run script
```sh
chmod +x setup_override.sh
```

Run Override file setup script
```sh
./setup_override.sh
```

**What the script does:**

- Copies the compose.override.yaml file from this repository to the industrial-robots-and-systems-world directory.

- Updates the compose.override.yaml file to link your local ~/IRS_2025_<group_number> directory to the Docker container's workspace.

<br>

## Launching the Containers

### 1. Start the Workspace

Once the setup script is complete, you can launch the Docker containers from the `industrial-robots-and-systems-world directory`.

Enter the folder
```sh
cd ~/industrial-robots-and-systems-world
```

Pull the latest docker containers
```bash
docker compose pull
```

Allow permission for UI interfaces from docker containers
```bash
xhost +local:root
```

Start the docker containers
```bash
docker compose up
```

Optional Flags:
```bash
docker compose up -d --build
```
- `docker compose up -d`: Use the `-d` (detached) flag to run the containers in the background.
- `docker compose up --build`: Use the `--build` flag to force a rebuild of the Docker image from the Dockerfile.

<br>

### 2. Access the Lab Shell

To access your code inside the running container, open a new terminal (if not using flag: `-d`) and execute a bash session inside the container. You can then navigate to your workspace to start development.

If not running, start the docker containers:
Enter the folder
```sh
cd ~/industrial-robots-and-systems-world
docker compose up -d --build
```

Execute new session
```bash
docker exec -it lab-shell /bin/bash
```

Navigate to workspace
```bash
cd ~/irslab_ws/src
```
Your local files from `~/IRS_2025_<group_number>` will be available in `~/irslab_ws/src>` inside the container.

<br>

## Stopping the Containers

### 1. Stop the Workspace

To stop the containers, run the following command from the `industrial-robots-and-systems-world` directory.

Enter the folder
```sh
cd ~/industrial-robots-and-systems-world
```

Stop the docker containers
```bash
docker compose stop
```

Remove docker containers
```bash
docker compose down
```

<br>

## Debugging

### Container Not Found &nbsp; | &nbsp; 'lab-shell' is not being found.

You can check that the container is running and that you are using the correct `name` for the `exec` command:

Find container name `<container_name>`
```bash
docker ps
```

Execute new session
```bash
docker exec -it <container_name> /bin/bash
```

<br>

### ROS2 Not Sourced &nbsp; | &nbsp; 'bash: ros2: command not found'

There may have been an issue with the custom docker sourcing the ros2 environment. In this case you may have to manually source it after every Docker restart. set

Execute session
```bash
docker exec -it lab-shell /bin/bash
```

Source ROS2 environment
```bash
source /opt/ros/humble/setup.bash
```

If you had this error you will likely have next error in this list.

<br>

### RMW Implementation Not Configured &nbsp; | &nbsp; 'Error getting RMW implementation identifier'

<pre><font color="#C01C28">[ERROR] [error_id] [rcl]: Error getting RMW implementation identifier / RMW implementation not installed (expected identifier of &apos;rmw_cyclonedds_cpp&apos;)...</font></pre>

This error means that the ROS 2 environment is not properly configured. The `ROS_DOMAIN_ID` and `RMW_IMPLEMENTATION` environment variables are likely missing from your container's configuration. This can happen if the docker's `compose.yaml` file is not correctly applying the environment variables defined in the `compose.override.yaml` file.

In this case, you will have to install the Middleware after every Docker restart and source it for every new session.

Execute session
```bash
docker exec -it lab-shell /bin/bash
```

Install Middleware
```bash
apt-get install ros-humble-rmw-cyclonedds-cpp
```

Update packages
```bash
apt-get update
```

Ensure Middleware is set correctly (should be perminantly set)
```bash
echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> ~/.bashrc
```

Source Middleware to apply changes
```bash
source ~/.bashrc
```

***
