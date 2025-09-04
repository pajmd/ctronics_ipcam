import sys
import subprocess
import psutil
import time
import os


# Ensure the 'repo' directory exists
if not os.path.exists('repo'):
    os.makedirs('repo')


user_name = os.environ.get('USER_NAME', 'default_user')
user_pwd = os.environ.get('USER_PWD', 'default_password')

fd_log = open('log/ipcam_ffmpeg.log', 'a')

base_process = subprocess.Popen(
    ['ffmpeg', '-hide_banner', '-y', '-loglevel', '+repeat+level+error', '-rtsp_transport', 'tcp', '-use_wallclock_as_timestamps', '1', '-i', 
    f'rtsp://{user_name}:{user_pwd}@192.168.1.43:554/11', '-vcodec', 'copy', '-acodec', 'copy', '-f', 'segment', '-reset_timestamps', '1', 
    '-segment_time', '600', '-segment_format', 'mkv', '-segment_atclocktime', '1', '-strftime', '1', 'repo/%Y%m%dT%H%M%S.mkv']
    , stdout=fd_log, stderr=fd_log
)

#Check process by CPU usage

control_process = psutil.Process(base_process.pid)
attempts = 10 

while base_process.poll() is None:
    cpu_percent = control_process.cpu_percent()
    print(f"ffmpeg cpu usage: {cpu_percent} {psutil.Process(base_process.pid).name}", file=sys.stderr)

    if cpu_percent == 0.0:
        attempts -= 1
        print(f"ffmpeg is not active, counting down, attempt left: {attempts}", file=sys.stderr)
    else:
        attempts = 10

    if attempts == 0:
        print("ffmpeg is hanging (CPU usage is 0%). Killing the process!", file=sys.stderr)
        while base_process.poll() is None:
            base_process.terminate()
            time.sleep(1)

        break
    #Sleep is 1 second, so if ffmpeg is not using cpu for 5 seconds, kill the process
    time.sleep(1)

