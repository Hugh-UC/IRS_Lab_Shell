# Lab Shell | Docker for Industrial Robots and Systems

Welcome to the Industrial Robots and Systems Lab Shell repository! Dockerfiles and build scripts for the IRS lab shell. This repository contains the environment configurations needed to run a development shell extension for Industrial Robots &amp; Systems lab, built on ROS 2 Humble. The provided scripts automatically configure your local environment to work with the main lab's `industrial-robots-and-systems-world` repository.

***

### Release (v1.0)

<br>

## Table of Contents

### Main README.md

- [Getting Started](#getting-started)
  - [1. Clone the Repositories](#1-clone-the-repositories)
  - [2. Run the Setup Script](#2-run-the-setup-script)
- [Launching the Containers](#launching-the-containers)
  - [1. Start the Workspace](#1-start-the-workspace)
  - [2. Access the Lab Shell](#2-access-the-lab-shell)
- [Stopping the Containers](#stopping-the-containers)
  - [1. Stop the Workspace](#1-stop-the-workspace)

<br>

- [Recomended Directory Structure](#recomended-directory-structure)

<br>

- [Debugging](#debugging)
  - [GHCR Pull Denial](#ghcr-pull-denial----response-denied)
  - [Container Not Found](#container-not-found--lab-shell-is-not-being-found)
  - [ROS2 Not Sourced](#ros2-not-sourced--bash-ros2-command-not-found)
  - [RMW Implementation Not Configured](#rmw-implementation-not-configured--error-getting-rmw-implementation-identifier)
  - [Store Authentication Credentials](#store-authentication-credentials-temporarily)

<br>

- [IRS_Lab_Shell as Submodule](#irs_lab_shell-as-submodule)
  - [Setting Up Submodule](#setting-up-submodule)
    - [1. Add to Group Repository](#1-add-to-group-repository)
    - [2. Clone your Repository with IRS_Lab_Shell](#2-clone-your-repository-with-irs_lab_shell)
  - [Update Submodule Pointer](#update-submodule-pointer)
    - [1. Update the Submodule](#1-update-the-submodule)
    - [2. Update Submodule Pointer](#2-update-submodule-pointer)


### Lab Specific README.md

- [Lab 5 Instructions](./Lab5-README.md)

<br>

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

**OR**

If using as a submodule (see: '[IRS_Lab_Shell as Submodule](#irs_lab_shell-as-submodule)')
```sh
cd ~/IRS_2025_<groups_number>/lab_shell_docker/scripts
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

Optional Environment Flag:
```sh
COLCON=true docker compose up
```
- `docker compose up -d`: Use the `-d` (detached) flag to run the containers in the background.
- `docker compose up --build`: Use the `--build` flag to force a rebuild of the Docker image from the Dockerfile.
- `COLCON=true docker compose up`: Use `COLCON=true` to pass a signal to the entrypoint script to execute **`colcon build`** on initialisation.

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
docker exec -it lab-shell /bin/bash -l
```

Navigate to workspace
```sh
cd ~/irslab_ws
```
Your local files from `~/IRS_2025_<group_number>` will be available in `~/irslab_ws` inside the container.

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

<br>

## Recomended Directory Structure

The repository structure below is **recommended** to maintain a clean workspace for **ROS 2 development** and to ensure seamless operation within the Docker environment.

### Key Principles

1. **Separate Source Code:** All new lab packages and custom code **must** live within the dedicated **`src`** directory.
    - Ensures packages can be built correctly within the ROS 2 environment.
    - Keeps your code separate from temporary build files.
2. **Submodule Location:** This repository, `lab_shell_docker`, **should** reside in your group repository's root directory, **`~/IRS_2025_<group_number>`**, to ensure a consistent and predictable workspace structure for all collaborators.
    - This is best practice when integrating a core development tool as a top-level Git submodule.
3. **Package Build Directories:** During the ROS 2 build process (`colcon build`) in `~/irslab_ws`, folders like `build`, `install`, and `log` are generated into your group repository root.
    - These files can be kept, only requiring built packages to be sourced in each new terminal session (`source install/local_setup.bash`).
    - Alternatively, it is best practice to ignore these files, adding them to a `.gitignore` file.

**UPDATE (v1.1):** `source install/local_setup.bash` no longer needs to be run for any new terminal session! `source install/local_setup.bash` is only necessary for newly built packages (`colcon build`).

<br>

### Example Directory Structure

```markdown
  IRS_2025_<group_number>/ (Your Group Repository Root)
  │
  ├── lab_shell_docker/         <-- ❗This repository as a submodule  (IRS_Lab_Shell)
  │   ├── Dockerfile
  │   ├── .github/workflows/
  │   │   └── lab-shell-humble.yml
  │   ├── lib/
  │   │   └── compose.override.yaml
  │   └── scripts/
  │       └── setup_override.sh 
  │
  ├── src/                      <-- ❗All your custom ROS 2 lab packages go here
  │   ├── hand_solo_arm/
  │   ├── hand_solo_virtual_nav/
  │   ├── pa_warehouse_status/
  │   ├── tmr_ros2/
  │   └── ...
  │                             --| Other Files
  ├── maps/
  ├── build/                    <-- ⚠️ Generated by 'colcon build'
  ├── install/                  <-- ⚠️ Generated by 'colcon build'
  ├── log/                      <-- ⚠️ Generated by 'colcon build'
  │
  ├── README.md
  ├── .gitmodules
  └── .gitignore
```

<br>

<br>

## Debugging

### GHCR Pull Denial &nbsp; | &nbsp; response: denied

`Error response from daemon: Head "https://ghcr.io/v2/... denied: denied`

If you have received a similar error message when trying to use `docker compose pull`, use the following command to clear any credentials for `ghcr.io`:

Enter the lab docker folder
```sh
cd ~/industrial-robots-and-systems-world
```

Execute clear credentials
```sh
docker logout ghcr.io
```

Re-run pull request
```sh
docker compose pull
```

<br>

### Container Not Found &nbsp; | &nbsp; 'lab-shell' is not being found.

You can check that the container is running and that you are using the correct `name` for the `exec` command:

Find container name `<container_name>`
```sh
docker ps
```

Execute new session
```sh
docker exec -it <container_name> /bin/bash -l
```

<br>

### ROS2 Not Sourced &nbsp; | &nbsp; 'bash: ros2: command not found'

There may have been an issue with the custom docker sourcing the ros2 environment. In this case you may have to manually source it after every Docker restart. set

Execute session
```sh
docker exec -it lab-shell /bin/bash -l
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
docker exec -it lab-shell /bin/bash -l
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

<br>

### Store Authentication Credentials (Temporarily)

You can temporarily store your GitHub authentication credentials by:

Set a timer to store credentials using 'cache helper'
```sh
git config --global credential.helper 'cache --timeout=86400'
```
Timeouts:
- 1 hour : &nbsp; &nbsp; &nbsp; timeout=3600
- 24 hours : &nbsp; timeout=86400

Next used of credentials is cached (removed on timeout)
```sh
git push origin main
```

<br>

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

Enter Credentials
Enter your GitHub username, replace `<github_username>`
```sh
Username for 'https://github.com': <github_username>
```

Enter your [Personal Access Token (classic)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic), replace `<personal_access_token>`
```sh
Password for 'https://<github_username>@github.com': <personal_access_token>
```

**Optional:** You can store your credentials for multiple uses before pushing a commit by follow the steps under: [Debugging](#debugging) > [Store Authentication Credentials](#store-authentication-credentials-temporarily)

<br>

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

<br>

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




