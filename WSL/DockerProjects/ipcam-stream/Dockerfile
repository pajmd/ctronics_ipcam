# Create local host volume
# sudo docker volume create ipcam-stream-data-host
#
# Visualize the volume on the host
# sudo docker volume inspect ipcam-stream-data-host
#
# Running named container as a deamon
# sudo docker run -d --name ipcam -v ipcam-stream-data-host:/usr/src/app/repo ipcam-stream-app
#
# List running containers
# sudo docker ps
#
# Open basth interactive on running conatainer
# sudo docker exec -it ipcam /bin/bash
#
# Stop running container
# sudo docker stop ipcam
#
#
# Docker file
#
# The image pulled will automatically be a variant based on the architecture
FROM ubuntu:latest

WORKDIR /usr/src/app
RUN apt-get update && apt-get install -y ffmpeg
# Copy script in WORKDIR
COPY ./save-rtsp-stream.sh .
RUN mkdir repo
CMD ["./save-rtsp-stream.sh"]
