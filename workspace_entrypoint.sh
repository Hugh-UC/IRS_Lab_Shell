#!/bin/bash
# -----------------------------------------------------------------------------
# ROS 2 Container Entrypoint Script
# -----------------------------------------------------------------------------
# This script is the primary execution point for the Docker container.
# Its main tasks are to source the ROS 2 environment, conditionally build
# the workspace if requested via an environment variable, and source the
# built workspace before executing the main container command (CMD).
# -----------------------------------------------------------------------------

# Exit immediately if a command exits with a non-zero status.
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


# Process BOTH C++ and Python packages.
echo "Checking for local workspace source code and build signal (for a full build)..."

# Check Docker environment variable
if [ "$RUN_COLCON_BUILD" = "true" ]; then
    echo "Running colcon build on mounted volume $WORKSPACE_ROOT..."

    cd "$WORKSPACE_ROOT"
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release \
                --event-handlers console_direct+
    
    echo "Colcon Build Complete."
else
    echo "WARNING: No build signal detected. Skipping colcon build."
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

# Execution complete
echo "Setup Complete!"

# Execute container command
exec "$@"