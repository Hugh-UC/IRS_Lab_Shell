#!/bin/bash
set -e

# Source the global ROS environment setup
if [ -f "/opt/ros/$ROS_DISTRO/setup.bash" ]; then
    echo "Sourcing global ROS environment: /opt/ros/$ROS_DISTRO/setup.bash"
    source "/opt/ros/$ROS_DISTRO/setup.bash"
else
	echo "notfound /opt/ros/$ROS_DISTRO/setup.bash"

    echo "sourcing /opt/ros/$ROS_DISTRO/install/setup.bash"
    source /opt/ros/$ROS_DISTRO/install/setup.bash
fi

# Source the local workspace setup, if it exists
#if [ -f "$WORKSPACE_ROOT/install/setup.bash" ]; then
#    echo "Sourcing local ROS workspace: $WORKSPACE_ROOT/install/setup.bash"
#    source "$WORKSPACE_ROOT/install/setup.bash"
#fi

WORKSPACE_ROOT="/root/irslab_ws"
cd "WORKSPACE_ROOT"

if [ -f "$WORKSPACE_ROOT/install/setup.bash" ]; then
    echo "Sourcing local ROS workspace: $WORKSPACE_ROOT/install/setup.bash"
    source "$WORKSPACE_ROOT/install/setup.bash"
else
    echo "Sourcing local ROS workspace: $WORKSPACE_ROOT/install/local_setup.bash"
    source "$WORKSPACE_ROOT/install/local_setup.bash"
fi

exec "$@"