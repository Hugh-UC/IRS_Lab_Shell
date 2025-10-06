#!/bin/bash
set -e

WORKSPACE_ROOT="/root/irslab_ws"

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

if [ -f "$WORKSPACE_ROOT/install/setup.bash" ]; then
    echo "Sourcing local ROS workspace: $WORKSPACE_ROOT/install/setup.bash"
    source "$WORKSPACE_ROOT/install/setup.bash"
elif [ -f "$WORKSPACE_ROOT/install/local_setup.bash" ]; then
    echo "Sourcing local ROS workspace: $WORKSPACE_ROOT/install/local_setup.bash"
    source "$WORKSPACE_ROOT/install/local_setup.bash"
else
    echo "notfound $WORKSPACE_ROOT/install/setup.bash \n or \n $WORKSPACE_ROOT/install/local_setup.bash"
fi

exec "$@"