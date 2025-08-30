#!/bin/bash

# This script comes from
# source https://medium.com/@tom.humph/saving-rtsp-camera-streams-with-ffmpeg-baab7e80d767

# To generate RTSP URL I used https://www.ispyconnect.com/camera/ctronics
# rtsp://admin:admin@192.168.1.20:554/11

# Using docker -e USER_NAME=... or docker compose.yaml environment:, I can replacd hard coded user/password
echo "USER_NAME="$USER_NAME" and USER_PWD="$USER_PWD > app.log

ffmpeg -hide_banner -y -loglevel error -rtsp_transport tcp -use_wallclock_as_timestamps 1 -i rtsp://$USER_NAME:$USER_PWD@192.168.1.43:554/11 -vcodec copy -acodec copy -f segment -reset_timestamps 1 -segment_time 10 -segment_format mkv -segment_atclocktime 1 -strftime 1 repo/%Y%m%dT%H%M%S.mkv
