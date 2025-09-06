#!/bin/bash
set -e

# Source the ROS 2 environment
source /opt/ros/humble/setup.bash

# Execute the command passed into this entrypoint
exec "$@"
