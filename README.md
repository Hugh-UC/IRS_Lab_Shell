# Lab Shell | Docker for Industrial Robots and Systems

Welcome to the Industrial Robots and Systems Lab Shell repository! Dockerfiles and build scripts for the IRS lab shell. This repository contains the environment configurations needed to run a development shell extension for Industrial Robots &amp; Systems lab, built on ROS 2 Humble. The provided scripts automatically configure your local environment to work with the main lab's `industrial-robots-and-systems-world` repository.

***

<br>

### Lab Specific Instructions

- [Click here for Lab 5 Instructions](./Lab5-README.md)

<br>

## Getting Started

### 1. Clone the Repositories

First, you need to clone both the main lab repository, your group repository and THEN this repository. You should clone them into your user's home directory (`~`).


Clone the '[Collaborative Robotics Lab](https://github.com/CollaborativeRoboticsLab/industrial-robots-and-systems-world.git)' lab repository
```sh
git clone https://github.com/CollaborativeRoboticsLab/industrial-robots-and-systems-world.git ~/industrial-robots-and-systems-world
```

Clone your group repository
```sh
# replace <github_user> with your github user name and <group_number> with your group's number (i.e. 07)
git clone https://github.com/<github_user>/IRS_2025_<groups_number>.git ~/IRS_2025_<group_number>
```

Clone [this repository](https://github.com/Hugh-UC/IRS_Lab_Shell)
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
- Copies the `compose.override.yaml` file from this repository to the `industrial-robots-and-systems-world` directory.
- Updates the `compose.override.yaml` file to link your local `~/IRS_2025_<group_number> directory` to the Docker container's workspace.

<br>

## Launching the Containers

### 1. Start the Workspace

Once the setup script is complete, you can launch the Docker containers from the `industrial-robots-and-systems-world directory`.

Enter the folder
```sh
cd ~/industrial-robots-and-systems-world
```

Pull the latest docker containers
```sh
docker compose pull
```

Allow permission for UI interfaces from docker containers
```sh
xhost +local:root
```

Start the docker containers
```sh
docker compose up
```

Optional Flags:
```sh
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
```sh
docker exec -it lab-shell /bin/bash
```

Navigate to workspace
```sh
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
```sh
docker compose stop
```

Remove docker containers
```sh
docker compose down
```

<br>

## Debugging

### Container Not Found &nbsp; | &nbsp; 'lab-shell' is not being found.

You can check that the container is running and that you are using the correct `name` for the `exec` command:

Find container name `<container_name>`
```sh
docker ps
```

Execute new session
```sh
docker exec -it <container_name> /bin/bash
```

<br>

### ROS2 Not Sourced &nbsp; | &nbsp; 'bash: ros2: command not found'

There may have been an issue with the custom docker sourcing the ros2 environment. In this case you may have to manually source it after every Docker restart. set

Execute session
```sh
docker exec -it lab-shell /bin/bash
```

Source ROS2 environment
```sh
source /opt/ros/humble/setup.bash
```

If you had this error you will likely have next error in this list.

<br>

### RMW Implementation Not Configured &nbsp; | &nbsp; 'Error getting RMW implementation identifier'

<pre><font color="#C01C28">[ERROR] [error_id] [rcl]: Error getting RMW implementation identifier / RMW implementation not installed (expected identifier of &apos;rmw_cyclonedds_cpp&apos;)...</font></pre>

This error means that the ROS 2 environment is not properly configured. The `ROS_DOMAIN_ID` and `RMW_IMPLEMENTATION` environment variables are likely missing from your container's configuration. This can happen if the docker's `compose.yaml` file is not correctly applying the environment variables defined in the `compose.override.yaml` file.

In this case, you will have to install the Middleware after every Docker restart and source it for every new session.

Execute session
```sh
docker exec -it lab-shell /bin/bash
```

Install Middleware
```sh
apt-get install ros-humble-rmw-cyclonedds-cpp
```

Update packages
```sh
apt-get update
```

Ensure Middleware is set correctly (should be perminantly set)
```sh
echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> ~/.bashrc
```

Source Middleware to apply changes
```sh
source ~/.bashrc
```

***

<br>

# IRS_Lab_Shell as Submodule

This section explains how to use this repository as a submodule within your group's repository (`IRS_2025_<group_number>`).
It also describes how to update the submodule pointer if any changes are made to this repository.

<br>

## Setting Up Submodule

### 1. Add to Group Repository

Navigate to group repository (IRS_2025_<group_number>)
```sh
cd ~/IRS_2025_<group_number>
```

Add submodule to repository
```sh
git submodule add https://github.com/Hugh-UC/IRS_Lab_Shell.git lab_shell_docker
```
**What this command does:**
- Create a new directory named `lab_shell_docker`.
- Create a `.gitmodules` file in your main repository's root.
  - Records the URL and the specific commit from this `IRS_Lab_Shell` repository.

Commit and Push Submodule
```sh
git add .
git commit -m "Adding IRS_Lab_Shell development docker as a Git submodule"
git push origin main
```

### 2. Clone your Repository with IRS_Lab_Shell
```sh
git clone --recurse-submodules https://github.com/<github_user>/IRS_2025_<groups_number>.git ~/IRS_2025_<group_number>
```

**What this command does:**
- `--recurse-submodules`: This flag tells Git to not only clone the main repository but also to automatically initialize and update any submodules that it finds.

<br>

## Update Submodule Pointer

To synchronize any changes in this repository with your IRS_2025_<group_number> repository, you need to update the submodule's pointer of your repository. This involves pulling the latest commits within the submodule and then committing that change to the main repository.

### 1. Update the Submodule

Navigate to Lab Shell repository
```sh
cd ~/IRS_2025_<group_number>/lab_shell_docker
```

Pull latest repository changes
```sh
git pull origin main
```

To ignore local changes before pull
```sh
git reset --hard origin/main
```

### 2. Update Submodule Pointer

Navigate back to the main repository folder
```sh
cd ..
```

Update and commit submodule changes
```sh
git add lab_shell_docker
git commit -m "chore: Update IRS_Lab_Shell submodule to latest commit"
git push origin main
```

***




