
Aps
===========

A Helm chart for Installing ISecL-DC Attestation policy service (APS)


## Configuration

The following table lists the configurable parameters of the Aps chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `nameOverride` | The name for APS chart<br> (Default: `.Chart.Name`) | `""` |
| `dependentServices.cms` |  | `"cms"` |
| `dependentServices.aas` |  | `"aas"` |
| `controlPlaneHostname` | K8s control plane IP/Hostname<br> (**REQUIRED**) | `"<user input>"` |
| `config.envVarPrefix` |  | `"APS"` |
| `config.dbPort` | PostgreSQL DB port | `5432` |
| `config.dbSSL` | PostgreSQL DB SSL<br> (Allowed: `on`/`off`) | `"on"` |
| `config.dbSSLCert` | PostgreSQL DB SSL Cert | `"/etc/postgresql/secrets/server.crt"` |
| `config.dbSSLKey` | PostgreSQL DB SSL Key | `"/etc/postgresql/secrets/server.key"` |
| `config.dbSSLCiphers` | PostgreSQL DB SSL Ciphers | `"ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256"` |
| `config.dbListenAddresses` | PostgreSQL DB Listen Address | `"*"` |
| `config.dbName` | APS DB Name | `"aps_db"` |
| `config.dbSSLMode` | PostgreSQL DB SSL Mode | `"verify-full"` |
| `config.vender` |  | `"postgres"` |
| `config.dbSSLCertSource` |  | `"/usr/local/pgsql/data/server.crt"` |
| `secret.dbUsername` | DB Username for APS DB | `"apsdbuser"` |
| `secret.dbPassword` | DB Password for APS DB | `"apsdbpassword"` |
| `secret.adminUsername` | Admin Username for APS | `"apsAdminUser"` |
| `secret.adminPassword` | Admin Password for APS | `"apsAdminPass"` |
| `secret.serviceUser` |  | `"aps"` |
| `secret.servicePassord` |  | `"aps"` |
| `image.db.registry` | The image registry where PostgreSQL image is pulled from | `"dockerhub.io"` |
| `image.db.name` | The image name of PostgreSQL | `"postgres:11.7"` |
| `image.db.pullPolicy` | The pull policy for pulling from container registry for PostgreSQL image<br> (Allowed values: `Always`/`IfNotPresent`) | `"Always"` |
| `image.svc.registry` | The image registry where APS image is pushed<br> (**REQUIRED**) | `"<user input>"` |
| `image.svc.name` | The image name with which APS image is pushed to registry<br> (**REQUIRED**) | `"<user input>"` |
| `image.svc.pullPolicy` | The pull policy for pulling from container registry for APS<br> (Allowed values: `Always`/`IfNotPresent`) | `"Always"` |
| `storage.nfs.server` | The NFS Server IP/Hostname<br> (**REQUIRED**) | `"<user input>"` |
| `storage.nfs.reclaimPolicy` | The reclaim policy for NFS<br> (Allowed values: `Retain`/) | `"Retain"` |
| `storage.nfs.accessModes` | The access modes for NFS<br> (Allowed values: `ReadWriteMany`) | `"ReadWriteMany"` |
| `storage.nfs.path` | The path for storing persistent data on NFS | `"/mnt/nfs_share"` |
| `storage.nfs.dbSize` | The DB size for storing DB data for HVS in NFS path | `"5Gi"` |
| `storage.nfs.configSize` | The configuration size for storing config for HVS in NFS path | `"10Mi"` |
| `storage.nfs.logsSize` | The logs size for storing logs for HVS in NFS path | `"1Gi"` |
| `storage.nfs.baseSize` | The base volume size (configSize + logSize + dbSize) | `"6.1Gi"` |
| `securityContext.apsdbInit.fsGroup` |  | `1001` |
| `securityContext.aps.runAsUser` |  | `1001` |
| `securityContext.aps.runAsGroup` |  | `1001` |
| `securityContext.aps.capabilities.drop` |  | `["all"]` |
| `securityContext.aps.allowPrivilegeEscalation` |  | `false` |
| `service.directoryName` |  | `"aps"` |
| `service.cms.containerPort` | The containerPort on which CMS can listen | `8445` |
| `service.cms.port` | The externally exposed NodePort on which CMS can listen to external traffic | `30445` |
| `service.aas.containerPort` | The containerPort on which AAS can listen | `8444` |
| `service.aas.port` | The externally exposed NodePort on which AAS can listen to external traffic | `30444` |
| `service.qvs.containerPort` | The containerPort on which QVS can listen to traffic | `12000` |
| `service.qvs.port` | The externally exposed NodePort on which QVS can listen to external traffic | `30501` |
| `service.aps.containerPort` | The containerPort on which APS can listen to traffic | `8445` |
| `service.aps.port` | The externally exposed NodePort on which APS can listen to external traffic | `50503` |
| `service.apsdb.containerPort` | The containerPort on which apsdb can listen to traffic | `5432` |



---
_Documentation generated by [Frigate](https://frigate.readthedocs.io)._

