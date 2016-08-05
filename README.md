# Docker image for Android SDK and JDK8

A docker image for Android SDK and JDK8 with SSHD installed so that it is possible to SSH to the container

## Pre-requisites
* [Docker] (https://www.docker.com/) is installed
* Git is installed

## How to use
* Clone the project on your local and go the project root 
* Build the image `docker build android:android-1.0 .`
* Check the image id by using `docker images`command
* Run the container by givin image id from previous command `docker run -t -i {yourImageId}`
* Check if the container is up and running `docker ps -a`, and pick the port where it is running if you want to ssh to the container
* Connect to the container `ssh android@localhost -p {portYouPickFromPreviousCommand}`
