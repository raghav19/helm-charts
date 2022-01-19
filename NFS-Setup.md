# Deploying NFS Server on a Virtual Machine	

## Pre-requisites

* Ubuntu/RHEL VM
* Export directory to use (Default: `/mnt/nfs_share/`)
* User ID for ISecL Services (Default: `1001`)
* Worker Node Subnet (Default: `*`)

## Script

Below is a sample script to deploy NFS Server, Directories & Permissions for ISecL services on a Ubuntu Virtual Machine

```shell
#!/bin/bash

# This script should be executed on Linux Ubuntu Virtual Machine

EXPORT_DIRECTORY=${1:-/mnt/nfs_share/}
USER_ID=${2:-1001}
WORKER_NODE_SUBNET=${3:-*}
SERVICES="cms ihub kbs"
SERVICES_WITH_DB="wls hvs aas"
BASE_PATH=isecl
LOG_PATH=logs
CONFIG_PATH=config
DB_PATH=db

echo "Updating packages"
apt-get -y update

echo "Installing NFS kernel server"
apt-get -y install nfs-kernel-server

echo "Making new directory to be: ${EXPORT_DIRECTORY}"
mkdir -p ${EXPORT_DIRECTORY}

echo "Create directories for isecl services and set permissions"
services=$(eval "echo \$SERVICES")
services_db=$(eval "echo \$SERVICES_WITH_DB")

mkdir -p $BASE_PATH && chmod 711 -R $BASE_PATH && chown -R $USER_ID:$USER_ID $BASE_PATH
for service in $services; do
  service=$BASE_PATH/$service
  mkdir -p $service && chown -R $USER_ID:$USER_ID $service
  mkdir -p $service/$LOG_PATH
  mkdir -p $service/$CONFIG_PATH
  chown -R $USER_ID:$USER_ID $service/$CONFIG_PATH
  chown -R $USER_ID:$USER_ID $service/$LOG_PATH
  if [ $service == "$BASE_PATH/kbs" ]; then
    mkdir -p $service/opt
    chown -R $USER_ID:$USER_ID $service/opt
  fi
done

for service in $services_db; do
  service=$BASE_PATH/$service
  mkdir -p $service && chown -R $USER_ID:$USER_ID $service
  mkdir -p $service/$LOG_PATH
  mkdir -p $service/$CONFIG_PATH
  mkdir -p $service/$DB_PATH
  chown -R $USER_ID:$USER_ID $service/$CONFIG_PATH
  chown -R $USER_ID:$USER_ID $service/$LOG_PATH
  chown -R $USER_ID:$USER_ID $service/$DB_PATH
done
echo "Appending NFS path and Worker Node Subnet to exports configuration file if export directory does not exist"
grep -qx "${EXPORT_DIRECTORY}/${BASE_PATH}/        ${WORKER_NODE_SUBNET}(rw,sync,no_all_squash,root_squash)" /etc/exports || echo "${EXPORT_DIRECTORY}/${BASE_PATH}/        ${WORKER_NODE_SUBNET}(rw,sync,no_all_squash,root_squash)" >> /etc/exports

echo "Restarting nfs-utils & exporting"
nohup service nfs-kernel-server restart
exportfs -arv
```

Below is a sample script to deploy NFS Server, Directories & Permissions on a RHEL Virtual Machine

```shell
#!/bin/bash

# This script should be executed on Linux RHEL Virtual Machine

EXPORT_DIRECTORY=${1:-/mnt/nfs_share/}
USER_ID=${2:-1001}
WORKER_NODE_SUBNET=${3:-*}
SERVICES="cms ihub kbs"
SERVICES_WITH_DB="wls hvs aas"
BASE_PATH=isecl
LOG_PATH=logs
CONFIG_PATH=config
DB_PATH=db

echo "Installing NFS Utils"
dnf install -y nfs-utils

echo "Making new directory to be: ${EXPORT_DIRECTORY}"
mkdir -p ${EXPORT_DIRECTORY}

echo "Create directories for isecl services and set permissions"
services=$(eval "echo \$SERVICES")
services_db=$(eval "echo \$SERVICES_WITH_DB")

mkdir -p $BASE_PATH && chmod 711 -R $BASE_PATH && chown -R $USER_ID:$USER_ID $BASE_PATH
for service in $services; do
  service=$BASE_PATH/$service
  mkdir -p $service && chown -R $USER_ID:$USER_ID $service
  mkdir -p $service/$LOG_PATH
  mkdir -p $service/$CONFIG_PATH
  chown -R $USER_ID:$USER_ID $service/$CONFIG_PATH
  chown -R $USER_ID:$USER_ID $service/$LOG_PATH
  if [ $service == "$BASE_PATH/kbs" ]; then
    mkdir -p $service/opt
    chown -R $USER_ID:$USER_ID $service/opt
  fi
done

for service in $services_db; do
  service=$BASE_PATH/$service
  mkdir -p $service && chown -R $USER_ID:$USER_ID $service
  mkdir -p $service/$LOG_PATH
  mkdir -p $service/$CONFIG_PATH
  mkdir -p $service/$DB_PATH
  chown -R $USER_ID:$USER_ID $service/$CONFIG_PATH
  chown -R $USER_ID:$USER_ID $service/$LOG_PATH
  chown -R $USER_ID:$USER_ID $service/$DB_PATH
done

echo "Appending NFS path and Worker Node Subnet to exports configuration file if export directory does not exist"
grep -qx "${EXPORT_DIRECTORY}/${BASE_PATH}/        ${WORKER_NODE_SUBNET}(rw,sync,no_all_squash,root_squash)" /etc/exports || echo "${EXPORT_DIRECTORY}/${BASE_PATH}/        ${WORKER_NODE_SUBNET}(rw,sync,no_all_squash,root_squash)" >> /etc/exports

echo "Restarting nfs-utils & exporting"
nohup service nfs-utils restart
exportfs -arv
```

## How to run
* Copy the sample script to the specific location on the machine (/root) to a file (e.g: setup-nfs.sh)
* Provide executable permissions
  ```shell
  chmod +x setup-nfs.sh
  ```
* Run the sample script as follows
  ```shell
  ./setup-nfs.sh /mnt/nfs_share 1001 <Subnet of worker node>
  ```
