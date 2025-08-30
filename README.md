# Ctronics iPcam

This project is about capturing the Ctronic IP Cam stream to save it on my NAS.

Since my OMV has a Docker plugin I decided to use Docker and Compose to manage the app.

The capturing is easily done using the **RSTP protocol** with **ffmpeg**.

## Docker on WSL DESKTOP-BJO8LJ8

Checkout all the files in WSL/DockerProjects/ipcam-stream, everything is self documented


## Docker on OMV

### Building the image

First we need to create an image for the app. 

In **Services > Compose > Dockerfiles** I Created a dockerfile **ipcam-dockerfile**.

Along with the dockerfile definition I added a script **in Script Filename**: save-rtsp-stream.sh . 
Not sure I should have created save-rtsp-stream.sh in **Script Filename** but it is a way to have it saved in the same folder as the Dockerfile 
```
/srv/dev-disk-by-uuid-a77d5d6f-f6d9-436a-a5a7-12810fa8cc53/appdata/ipcam-dockerfile
```
and this helps build the container without error when **COPY ./save-rtsp-stream.sh .** is executed . 

As far I as understand all the extra files I may have needed to create the image should be in the Dockerfile folder. 
i.e. /srv/dev-disk-by-uuid-a77d5d6f-f6d9-436a-a5a7-12810fa8cc53/appdata/ipcam-dockerfile. 

This is odd because this folder is created after **Build** image is executed.

At this point clicking on **Build** to build a container seems to create problems later on, when deploying the sercice
so refrain from doing it and let **compose** build the image and the container.

### Building the Compose file

The **compose.yaml** file is created in **Services > Compose > Files**

The plugin assumes the dockerfile is located in the same folder as the yaml.

Since my Dockerfile is not located in the same folder as my **compose.yaml** i.e. /srv/dev-disk-by-uuid-a77d5d6f-f6d9-436a-a5a7-12810fa8cc53/appdata/IPcam,
the **compose build** section needs a **context** sub-section to indicate the **Dockerfile's** location
```
  build:
    context: ../ipcam-dockerfile
```

#### Volume
In OMV **Compose > Settings** there are only two types of shared folders defined in **Storage > Shared** Folders all the sevices use.
* **appdata** where the app files like Dockerfiles, compose.yaml file ... are defined
* **data** used to mount voulmes for persisted app data. This folder's alias is **CHANGE_TO_COMPOSE_DATA_PATH** aka **/srv/dev-disk-by-uuid-a77d5d6f-f6d9-436a-a5a7-12810fa8cc53/data**

I created in **Storage** > **Shared Folder** a folder **data/ipcam_repo** to mount the app's repo
```
volumes:
      - CHANGE_TO_COMPOSE_DATA_PATH/ipcam_repo:/usr/src/app/repo
```

#### Environment variables
In the section **Environment** of the **Compose** definition I added variables that are passed to the app.
* USER_NAME=\<cam username>
* USER_PWD=\<cam password>
  

### Running the Service after modifying the Dockerfile or the script

To make sure everyhting is build correctly

* delete the container (seems like the only way to do it is with the CLI **sudo docker container rm ipcam-stream-app-container**)
* delete the image
* **UP** the service to rebuild the image, build the container and run it.
  

### Logging

ffmpeg logging is redirected in the container's /var/log/ipcam_ffmpeg.log mounted to **appdata/IPcam/log**.

## Playing the mkv files

We can use either **VLC** or select a bunch of filed and paly them in windows **Media Player**

