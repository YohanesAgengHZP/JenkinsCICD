FROM jenkins/jenkins:2.452.2-jdk17

# Switch to root to install packages
USER root

# Update package list and install lsb-release
RUN apt-get update && apt-get install -y lsb-release

# Add Docker's official GPG key
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg

# Add Docker's official repository
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Update package list and install Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli

# Install Python and Pip
RUN apt-get update && apt-get install -y python3 python3-pip

# Switch back to the jenkins user
USER jenkins

# Install plugins using jenkins-plugin-cli, including the missing json-path-api dependency
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow json-path-api"

# Install additional plugins that might be needed
RUN jenkins-plugin-cli --plugins "token-macro github-branch-source"
