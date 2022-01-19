
Wls
===========

A Helm chart for Installing ISecL-DC Workload Service


## Configuration

The following table lists the configurable parameters of the Wls chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `nameOverride` | The name for WLS chart<br> (Default: `.Chart.Name`) | `""` |
| `controlPlaneHostname` | K8s control plane IP/Hostname<br> (**REQUIRED**) | `"<user input>"` |
| `dependentServices.cms` |  | `"cms"` |
| `dependentServices.aas` |  | `"aas"` |
| `dependentServices.hvs` |  | `"hvs"` |
| `secret.adminUsername` | Admin Username for WLS | `"wlsAdminUser"` |
| `secret.adminPassword` | Admin Password for WLS | `"wlsAdminPass"` |
| `image.wls.registry` | The image registry where WLS image is pushed<br> (**REQUIRED**) | `"<user input>"` |
| `image.wls.name` | The image name with which CMS image is pushed to registry<br> (**REQUIRED**) | `"<user input>"` |
| `image.wls.pullPolicy` | The pull policy for pulling from container registry for WLS<br> (Allowed values: `Always`/`IfNotPresent`) | `"Always"` |
| `storage.nfs.server` | The NFS Server IP/Hostname<br> (**REQUIRED**) | `"<user input>"` |
| `storage.nfs.reclaimPolicy` | The reclaim policy for NFS<br> (Allowed values: `Retain`/) | `"Retain"` |
| `storage.nfs.accessModes` | The access modes for NFS<br> (Allowed values: `ReadWriteMany`) | `"ReadWriteMany"` |
| `storage.nfs.path` | The path for storing persistent data on NFS | `"/mnt/nfs_share"` |
| `storage.nfs.configSize` | The configuration size for storing config for WLS in NFS path | `"10Mi"` |
| `storage.nfs.logsSize` | The logs size for storing logs for WLS in NFS path | `"1Gi"` |
| `securityContext.wlsInit.fsGroup` |  | `1001` |
| `securityContext.wls.runAsUser` |  | `1001` |
| `securityContext.wls.runAsGroup` |  | `1001` |
| `securityContext.wls.capabilities.drop` |  | `["all"]` |
| `securityContext.wls.allowPrivilegeEscalation` |  | `false` |
| `service.cms.containerPort` | The containerPort on which CMS can listen | `8445` |
| `service.aas.containerPort` | The containerPort on which AAS can listen | `8444` |
| `service.hvs.containerPort` | The containerPort on which HVS can listen | `8443` |
| `service.wls.containerPort` | The containerPort on which WLS can listen | `5000` |
| `service.wls.port` | The externally exposed NodePort on which WLS can listen to external traffic | `30447` |



---
_Documentation generated by [Frigate](https://frigate.readthedocs.io)._
