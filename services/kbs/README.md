Kbs
===========

A Helm chart for Installing ISecL-DC Key Broker Service


## Configuration

The following table lists the configurable parameters of the Kbs chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `nameOverride` | The name for KBS chart<br> (Default: `.Chart.Name`) | `""` |
| `controlPlaneHostname` | K8s control plane IP/Hostname<br> (**REQUIRED**) | `"<user input>"` |
| `dependentServices.cms` |  | `"cms"` |
| `dependentServices.aas` |  | `"aas"` |
| `image.svc.registry` | The image registry where KBS image is pushed<br> (**REQUIRED**) | `"<user input>"` |
| `image.svc.name` | The image name with which KBS image is pushed to registry<br> (**REQUIRED**) | `"<user input>"` |
| `image.svc.pullPolicy` | The pull policy for pulling from container registry for KBS<br> (Allowed values: `Always`/`IfNotPresent`) | `"Always"` |
| `config.keyManager` | The Key manager for KBS (Allowed values: `kmip`) | `"kmip"` |
| `config.kmip.serverIp` | The KMIP server IP | `null` |
| `config.kmip.serverHostname` | The KMIP server hostname | `null` |
| `config.kmip.serverPort` | The KMIP server port | `5696` |
| `config.kmip.clientCertPath` | The KMIP server client certificate absolute path | `"/etc/kmip/client_certificate.pem"` |
| `config.kmip.clientKeyPath` | The KMIP server client key absolute path | `"/etc/kmip/client_key.pem"` |
| `config.kmip.rootCertPath` | The KMIP server root certificate absolute path | `"/etc/kmip/root_certificate.pem"` |
| `storage.nfs.server` | The NFS Server IP/Hostname<br> (**REQUIRED**) | `"<user input>"` |
| `storage.nfs.reclaimPolicy` | The reclaim policy for NFS<br> (Allowed values: `Retain`/) | `"Retain"` |
| `storage.nfs.accessModes` | The access modes for NFS<br> (Allowed values: `ReadWriteMany`) | `"ReadWriteMany"` |
| `storage.nfs.path` | The path for storing persistent data on NFS | `"/mnt/nfs_share"` |
| `storage.nfs.configSize` | The configuration size for storing config for KBS in NFS path | `"10Mi"` |
| `storage.nfs.logsSize` | The logs size for storing logs for KBS in NFS path | `"1Gi"` |
| `storage.nfs.baseSize` | The base volume size (configSize + logSize) | `"1.1Gi"` |
| `securityContext.init.fsGroup` |  | `1001` |
| `securityContext.kbs.runAsUser` |  | `1001` |
| `securityContext.kbs.runAsGroup` |  | `1001` |
| `securityContext.kbs.capabilities.drop` |  | `["all"]` |
| `securityContext.kbs.allowPrivilegeEscalation` |  | `false` |
| `service.directoryName` |  | `"kbs"` |
| `service.cms.containerPort` | The containerPort on which CMS can listen to traffic | `8445` |
| `service.aas.containerPort` | The containerPort on which AAS can listen to traffic | `8444` |
| `service.kbs.containerPort` | The containerPort on which KBS can listen to traffic | `9443` |
| `service.kbs.port` | The externally exposed NodePort on which KBS can listen to external traffic | `30448` |
| `factory.nameOverride` |  | `""` |



---
_Documentation generated by [Frigate](https://frigate.readthedocs.io)._