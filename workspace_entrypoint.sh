#!/bin/bash
set -e

# Set ROS 2 workspace root
WORKSPACE_ROOT="/root/irslab_ws"

# Source the global ROS 2 environment setup
if [ -f "/opt/ros/$ROS_DISTRO/setup.bash" ]; then
    echo "Sourcing global ROS environment: /opt/ros/$ROS_DISTRO/setup.bash"
    source "/opt/ros/$ROS_DISTRO/setup.bash"

elif [ -f "/opt/ros/$ROS_DISTRO/install/setup.bash" ]; then
	echo "notfound: /opt/ros/$ROS_DISTRO/setup.bash"

    echo "sourcing /opt/ros/$ROS_DISTRO/install/setup.bash"
    source /opt/ros/$ROS_DISTRO/install/setup.bash

else
    echo "notfound: /opt/ros/$ROS_DISTRO/install/setup.bash"
    echo "WARNING: Base ROS environment not sourced!"
fi

# Source the local workspace setup, if it exists
if [ -f "$WORKSPACE_ROOT/install/local_setup.bash" ]; then
    echo "Sourcing local ROS workspace: $WORKSPACE_ROOT/install/local_setup.bash"
    source "$WORKSPACE_ROOT/install/local_setup.bash"

elif [ -f "$WORKSPACE_ROOT/install/setup.bash" ]; then
    echo "notfound: $WORKSPACE_ROOT/install/local_setup.bash"

    echo "Sourcing local ROS workspace: $WORKSPACE_ROOT/install/setup.bash"
    source "$WORKSPACE_ROOT/install/setup.bash"

else
    echo "notfound: $WORKSPACE_ROOT/install/setup.bash"
    echo "WARNING: Local workspace setup files not found in $WORKSPACE_ROOT/install/. Packages not sourced."
fi

echo "Setup Complete!"

exec "$@"