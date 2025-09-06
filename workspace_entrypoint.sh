#!/bin/bash
set -e

# Source the global ROS environment setup
if [ -f "/opt/ros/$ROS_DISTRO/setup.bash" ]; then
    echo "Sourcing global ROS environment: /opt/ros/$ROS_DISTRO/setup.bash"
    source "/opt/ros/$ROS_DISTRO/setup.bash"
fi

# Source the local workspace setup, if it exists
if [ -f "$WORKSPACE_ROOT/install/setup.bash" ]; then
    echo "Sourcing local ROS workspace: $WORKSPACE_ROOT/install/setup.bash"
    source "$WORKSPACE_ROOT/install/setup.bash"
fi

exec "$@"