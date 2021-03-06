Fda
===========

A Helm chart for Installing ISecL-DC Feature Discovery Agent


## Configuration

The following table lists the configurable parameters of the Fda chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `nameOverride` | The name for FDA chart<br> (Default: `.Chart.Name`) | `""` |
| `controlPlaneHostname` | K8s control plane IP/Hostname<br> (**REQUIRED**) | `"<user input>"` |
| `nodeLabel.sgx` | The node label for SGX-ENABLED hosts<br> (**REQUIRED IF NODE IS SGX ENABLED**) | `"SGX-ENABLED"` |
| `nodeLabel.tdx` | The node label for TDX-ENABLED hosts<br> (**REQUIRED IF NODE IS TDX ENABLED**) | `"TDX-ENABLED"` |
| `dependentServices.cms` |  | `"cms"` |
| `dependentServices.aas` |  | `"aas"` |
| `dependentServices.fda` |  | `"fda"` |
| `dependentServices.tcs` |  | `"tcs"` |
| `image.svc.registry` | The image registry where FDA image is pushed<br> (**REQUIRED**) | `"<user input>"` |
| `image.svc.name` | The image name with which CMS image is pushed to registry | `"<user input>"` |
| `image.svc.pullPolicy` | The pull policy for pulling from container registry for AAS<br> (Allowed values: `Always`/`IfNotPresent`) | `"Always"` |
| `storage.nfs.server` | The NFS Server IP/Hostname | `"<user input>"` |
| `storage.nfs.reclaimPolicy` | The reclaim policy for NFS<br> (Allowed values: `Retain`/) | `"Retain"` |
| `storage.nfs.accessModes` | The access modes for NFS<br> (Allowed values: `ReadWriteMany`) | `"ReadWriteMany"` |
| `storage.nfs.path` | The path for storing persistent data on NFS | `"/mnt/nfs_share"` |
| `storage.nfs.configSize` | The configuration size for storing config for AAS in NFS path | `"10Mi"` |
| `storage.nfs.logsSize` | The logs size for storing logs for AAS in NFS path | `"1Gi"` |
| `storage.nfs.baseSize` | The base volume size (configSize + logSize ) | `"2.1Gi"` |
| `config.refreshInterval` | Refresh Interval | `"<user input>"` |
| `config.retryCount` | Retry count | `"<user input>"` |
| `config.validitySeconds` | Validity of custom_token in seconds | `"<user input>"` |
| `secret.customToken` | Custom Token for FDA | `"<user input>"` |
| `service.directoryName` |  | `"fda"` |
| `service.cms.containerPort` | The containerPort on which CMS can listen | `8445` |
| `service.cms.port` | The externally exposed NodePort on which CMS can listen to external traffic | `30445` |
| `service.aas.containerPort` | The containerPort on which AAS can listen | `8444` |
| `service.aas.port` | The externally exposed NodePort on which AAS can listen to external traffic | `30444` |
| `service.fds.containerPort` | The containerPort on which FDS can listen | `13000` |
| `service.fds.port` |  | `30500` |
| `service.tcs.containerPort` | The containerPort on which TCS can listen | `9000` |
| `service.tcs.port` |  | `30501` |
| `proxy.http_proxy` | HTTP Proxy value | `"<user input>"` |
| `proxy.https_proxy` | HTTP Proxy value | `"<user input>"` |
| `proxy.no_proxy` | No Proxy value | `"<user input>"` |
| `factory.nameOverride` |  | `""` |



---
_Documentation generated by [Frigate](https://frigate.readthedocs.io)._
