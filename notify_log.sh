#!/bin/bash

title="$(whoami) Logged in"
message="Username : $(whoami)"
notify-send -t 3000 "$title" "$message"

log="[$(date)] Username : $(whoami) \n w: $(w) \n id: $(id) \n\n"
echo $log >> /home/viz/Desktop/ssh_logs.log

