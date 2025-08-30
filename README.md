# Ctronics iPcam

## Docker on WLS DESKTOP-BJO8LJ8

## Docker on OMV

### Building the image

I Created a dockerfile **ipcam-dockerfile** in Services > Compose > Dockerfiles.
Along with the dockerfile definition I addeds save-rtsp-stream.sh in Script Filename. 
Not sure I should have created save-rtsp-stream.sh in Script Filename but it is a way to have saved in the same folder as the Dockerfile 
```
/srv/dev-disk-by-uuid-a77d5d6f-f6d9-436a-a5a7-12810fa8cc53/appdata/ipcam-dockerfile
```
and this helps build the container without error while "COPY ./save-rtsp-stream.sh ." is executed . 

As far I as understand all the extra files I may have needed to create the image should be in the **Compose Settings Compose Files** for this image 
i.e. /srv/dev-disk-by-uuid-a77d5d6f-f6d9-436a-a5a7-12810fa8cc53/appdata/ipcam-dockerfile. 
This is odd because this folder is created after **Build** image is executed.

At this point clicking on **Build** to build a container seems to create problems later on when deploying the sercice
so I let **compose** build the image and the container.

### Building the Compose file

I found out somehow with the plugin we need to tell where the dockerfile is located otherwise it assumes its in the same folder as the yaml.

Since my Dockerfile is not located in the same folder as my **compose.yaml** /srv/dev-disk-by-uuid-a77d5d6f-f6d9-436a-a5a7-12810fa8cc53/appdata/IPcam
in the **build** section I have to add a **context** to indicate the **Dockerfile** location
```
context: ../ipcam-dockerfile
```

#### Volume
In OMV, it seems like the volume can only be created in **CHANGE_TO_COMPOSE_DATA_PATH** aka **/srv/dev-disk-by-uuid-a77d5d6f-f6d9-436a-a5a7-12810fa8cc53/data**
so I created in **Storage** > **Shared Folder** a folder **ipcam_repo** to mount the app repo
```
volumes:
      - CHANGE_TO_COMPOSE_DATA_PATH/ipcam_repo:/usr/src/app/repo
```

#### Environment variables
In the section **Environment** of the **Compose** definition I added the definition of the variables that will be passed to the app.

## Running the Service after modifying the Dockerfile od script

* delete the container
* delete the image
* **UP** the service to rebuild the image, build the container and run it.
* 
