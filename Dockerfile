# Use a base image with ROS Humble and Ubuntu Jammy
FROM ros:humble-ros-base-jammy AS base

# Set shell to bash
SHELL ["/bin/bash", "-c"]

# Set environment variables to match the lab setup for seamless ROS 2 communication
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV ROS_DOMAIN_ID=0
ENV DEBIAN_FRONTEND=noninteractive

# Install development tools and useful utilities
# The `&&` links commands together to reduce the number of image layers
RUN apt-get update && \
    apt-get install -y \
    nano \
    less \
    git \
    iproute2 \
    net-tools \
    python3-pip \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-dev \
    build-essential \
    curl \
    lsb-release \
    wget \
    gnupg2 \
    qtdeclarative5-dev \
    libqt5widgets5 \
    ros-humble-moveit \
    ros-humble-controller-manager \
    ros-humble-joint-trajectory-controller \
    ros-humble-joint-state-broadcaster \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-joint-state-publisher \
    ros-humble-joint-state-publisher-gui \
    ros-humble-vision-opencv \
    ros-humble-rviz2 \
    ros-humble-nav2-bringup \
    ros-humble-navigation2 \
    ros-humble-nav2-simple-commander \
    ros-humble-tf2-tools \
    ros-humble-rqt-tf-tree \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libgtk-3-0 \
    x11-xserver-utils \
    ffmpeg \
    libsm6 \
    unzip \
    findutils \
    libx11-dev \
    libxext-dev \
    libxtst-dev \
    libxrender-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Add ROS 2 environment sourcing to the bashrc file
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Create a directory for your ROS 2 workspace
WORKDIR /

# Optional: custom entrypoint (make sure this script exists)
COPY /workspace_entrypoint.sh /workspace_entrypoint.sh

RUN chmod +x /workspace_entrypoint.sh

# Entry point
ENTRYPOINT ["/workspace_entrypoint.sh"]

# Set the default command to keep the container running
CMD ["bash", "-l"]        # depricated: CMD ["tail", "-f", "/dev/null"]
