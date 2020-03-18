#!/bin/bash

VBoxManage='/c/Program Files/Oracle/VirtualBox/VBoxManage'

# Defines variables for later use.
ROOT=$(dirname $0)
ROOT=$(cd "$ROOT"; pwd)
MACHINE=default
PROJECT_KEY=shared-${ROOT##*/}
eval $(docker-machine env $MACHINE)

# Prepares machine (without calling "docker-machine stop" command).
#
if [ $(docker-machine status $MACHINE 2> /dev/null) = 'Running' ]; then
    echo Unmounting volume: $ROOT
    docker-compose down
    docker-machine ssh $MACHINE <<< '
        sudo umount "'$ROOT'";
    '
    "$VBoxManage" sharedfolder remove $MACHINE --name "$PROJECT_KEY" -transient > /dev/null 2>&1
fi
docker-machine start $MACHINE

set -euxo pipefail
"$VBoxManage" sharedfolder add $MACHINE --name "$PROJECT_KEY" --hostpath "$ROOT" -automount -transient


docker-machine ssh $MACHINE <<< '
    echo Mounting volume: '$ROOT';
    sudo mkdir -p "'$ROOT'";
    sudo mount -t vboxsf -o uid=1000,gid=50 "'$PROJECT_KEY'" "'$ROOT'";
'

docker-compose up -d --build
docker-machine ip
docker-machine ssh $MACHINE
bash