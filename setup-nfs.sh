#!/bin/bash

# This script should be executed on Linux RHEL Virtual Machine

EXPORT_DIRECTORY=${1:-/mnt/nfs_share/}
USER_ID=${2:-1001}
CURR_DIR=`pwd`
WORKER_NODE_SUBNET=${3:-*}
SERVICES="cms ihub kbs qvs"
SERVICES_WITH_DB="wls hvs authservice fds aps tcs"
BASE_PATH=$EXPORT_DIRECTORY/isecl
LOG_PATH=logs
CONFIG_PATH=config
DB_PATH=db
VERSION=${VERSION:-v4.1.0}
echo "Installing NFS Utils"
dnf install -y nfs-utils
echo "Making new directory to be: ${EXPORT_DIRECTORY}"
mkdir -p ${EXPORT_DIRECTORY}

echo "Create directories for isecl services and set permissions"
services=$(eval "echo \$SERVICES")
services_db=$(eval "echo \$SERVICES_WITH_DB")

mkdir -p $BASE_PATH && chmod 711 -R $BASE_PATH
for base_service in $services; do
  service=$BASE_PATH/$base_service/$VERSION
  mkdir -p $service && chown -R $USER_ID:$USER_ID $service
  mkdir -p $service/$LOG_PATH
  mkdir -p $service/$CONFIG_PATH
  chown -R $USER_ID:$USER_ID $service/$CONFIG_PATH
  chown -R $USER_ID:$USER_ID $service/$LOG_PATH
  if [ $service == "$BASE_PATH/kbs" ]; then
    mkdir -p $service/opt
    chown -R $USER_ID:$USER_ID $service/opt
    cd $BASE_PATH/$base_service
    ln -sfT $VERSION/opt opt
  fi
  cd $BASE_PATH/$base_service
  ln -sfT $VERSION/$CONFIG_PATH $CONFIG_PATH
  ln -sfT $VERSION/$LOG_PATH $LOG_PATH
done

cd $CURR_DIR

for base_service in $services_db; do
  service=$BASE_PATH/$base_service/$VERSION
  mkdir -p $service && chown -R $USER_ID:$USER_ID $service
  mkdir -p $service/$LOG_PATH
  mkdir -p $service/$CONFIG_PATH
  mkdir -p $service/$DB_PATH
  chown -R $USER_ID:$USER_ID $service/$CONFIG_PATH
  chown -R $USER_ID:$USER_ID $service/$LOG_PATH
  chown -R $USER_ID:$USER_ID $service/$DB_PATH
  cd $BASE_PATH/$base_service
  ln -sfT $VERSION/$CONFIG_PATH $CONFIG_PATH
  ln -sfT $VERSION/$LOG_PATH $LOG_PATH
  ln -sfT $VERSION/$DB_PATH $DB_PATH

done
cd $CURR_DIR
chown -R $USER_ID:$USER_ID $BASE_PATH

echo "Appending NFS path and Worker Node Subnet to exports configuration file if export directory does not exist"
grep -qx "${BASE_PATH}/        ${WORKER_NODE_SUBNET}(rw,sync,no_all_squash,root_squash)"  /etc/exports || echo "${BASE_PATH}/        ${WORKER_NODE_SUBNET}(rw,sync,no_all_squash,root_squash)" >> /etc/exports

echo "Restarting nfs-utils & exporting"
nohup service nfs-utils restart
exportfs -arv
