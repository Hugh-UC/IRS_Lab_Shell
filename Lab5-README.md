# Lab 5 | Instructions

## Required File Modifications

In order to properly complete this laboratory you must first edit the `compose.override.yaml` file.
This will disable the Docker container `omron_moma_ros2` by adding an override to the service that tells the container to exit immediately after starting.

<br>

### 1. Update Compose Override

Uncomment `command` line within your Docker `compose.override.yaml`

From
```yaml
omron_moma_ros2:
#    command: "true"
```

To
```yaml
# Disable service
omron_moma_ros2:
    command: "true"
```
(located at: `~/industrial-robots-and-systems-world`)

Rebuild your workspace
```sh
docker compose up -d --build
```

<br>

### 2. Test if Service is Disabled

Check container status
```sh
docker ps
```

The container should be disabled `Restarting (0)`
| CONTAINER ID | IMAGE | COMMAND | CREATED | STATUS | PORTS | NAMES |
| :----------- | :---- | :------ | :------ | :----- | :---- | :---- |
| cb2dd38ff6bc | ghcr.io/collaborativeroboticslab/industrial-robots-and-systems-omron-moma:humble | "/workspace_entrypoi…" | 3 seconds ago | Restarting (0) Less than a second ago | | industrial-robots-and-systems-world-omron_moma_ros2-1 |

Execute new session
```sh
docker exec -it lab-shell /bin/bash
```

Check reduced topic list
```sh
ros2 topic list
```

<br>

## Why is this required?

Disabling the `omron_moma_ros2` service is required because it publishes its own **Transform Tree (TF)** frames that conflict with the simulated robot's TF frames. This conflict is the reason the `rqt_tf_tree` doesn't work correctly and, subsequently, why mapping fails.

Conflict issues:
- **Broken TF Tree**: The ROS `tf2` library, which manages the TF tree, cannot resolve the ambiguity of having two different publishers for the same frame. This breaks the tree, making it impossible for `rqt_tf_tree` to display a single, coherent graph.
- **Mapping Failure**: Mapping algorithms, such as the one in `slam_toolbox`, depend entirely on a consistent and accurate TF tree. They need to know the precise location of the robot's laser scanner or camera relative to the map frame. When the TF tree is broken, the mapping algorithm loses its spatial reference and cannot accurately build a map.