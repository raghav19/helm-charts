# isecl-helm

A collection of helm charts for ISecL-DC usecases


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [isecl-helm](#isecl-helm)
  - [Getting Started](#getting-started)
    - [Pre-requisites](#pre-requisites)
    - [Support Details](#support-details)
    - [Use Case Helm Charts](#use-case-helm-charts)
      - [Foundational Security Usecases](#foundational-security-usecases)
      - [Workload Security Usecases](#workload-security-usecases)
      - [Confidential Computing Usecases](#confidential-computing-usecases)
    - [Setting up for Helm deployment](#setting-up-for-helm-deployment)
        - [Create Secrets for Database of Services](#create-secrets-for-database-of-services)
    - [Installing isecl-helm charts](#installing-isecl-helm-charts)
      - [Update `values.yaml` for Use Case chart deployments](#update-valuesyaml-for-use-case-chart-deployments)
      - [Use Case charts Deployment](#use-case-charts-deployment)
      - [Individual Service/Agent Charts Deployment](#individual-serviceagent-charts-deployment)

<!-- /code_chunk_output -->


## Getting Started
Below steps guide in the process for installing isecl-helm charts on a kubernetes cluster.

### Pre-requisites
* Non Managed Kubernetes Cluster up and running
* Helm 3 installed
  ```shell
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
  ```
* NFS setup
  > **Note:** A sample script for setting up NFS with the right permissions is provided in the `NFS-Setup.md` file

### Support Details

| Kubernetes        | Details                                                      |
| ----------------- | ------------------------------------------------------------ |
| Cluster OS        | *RedHat Enterprise Linux 8.x* <br/>*Ubuntu 18.04*            |
| Distributions     | Any non-managed K8s cluster                                  |
| Versions          | v1.21                                                        |
| Storage           | NFS                                                          |
| Container Runtime | Foundational Security: *docker*,*CRI-O*<br/>Workload Security: *CRI-O*<br/>Secure Key Caching: *docker* |

### Use Case Helm Charts 

#### Foundational Security Usecases

| Use case                                | Helm Charts                                        |
| --------------------------------------- | -------------------------------------------------- |
| Host Attestation                        | *cms*<br />*aas*<br />*hvs*<br />*ta*          |
| Trusted Workload Placement - Containers | *cms*<br />*aas*<br />*hvs*<br />*k8s-extensions*<br />*ihub*<br />*ta* |
| Data Fencing with Asset Tags            | *cms*<br />*aas*<br />*hvs*<br />*k8s-extensions*<br />*ihub*<br />*ta*              |

#### Workload Security Usecases

| Use case                                      | Helm Charts                                     |
| --------------------------------------------- | ----------------------------------------------- |
| Container Confidentiality with CRIO Runtime   | *cms*<br />*aas*<br />*hvs*<br />*k8s-extensions*<br />*ihub*<br />*wls*<br />*kbs*<br />*ta*<br />*wla*   |

#### Confidential Computing Usecases

| Use case           | Helm Charts                              |
| ------------------ | ---------------------------------------- |
| Secure Key Caching | *isecl-core*<br />*isecl-skc*            |
| SGX Attestation    | *isecl-core*<br />*isecl-sgxAttestation* |
| SGX Orchestration  | *isecl-core*<br />*isecl-sgxOrchestration*  |


### Setting up for Helm deployment

##### Create Secrets for ISecL Scheduler TLS Key-pair (Mandatory for Trusted workload placement usecase)
ISecl Scheduler runs as https service, therefore it needs TLS Keypair and tls certificate needs to be signed by K8s CA, inorder to have secure communication between K8s base scheduler and ISecl K8s Scheduler.
The creation of TLS keypair is a manual step, which has to be done prior deplolying the helm for Trusted Workload Placement usecase. 
Following are the steps involved in creating tls cert signed by K8s CA.
```shell
mkdir -p /tmp/k8s-certs/tls-certs && cd /tmp/k8s-certs/tls-certs
openssl req -new -x509 -days 365 -newkey rsa:4096 -addext "subjectAltName = DNS:<Controlplane hostname>" -nodes -text -out server.csr -keyout server.key -sha384 -subj "/CN=ISecl Scheduler TLS Certificate"

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: isecl-scheduler.isecl
spec:
  request: $(cat server.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
EOF

kubectl certificate approve isecl-scheduler.isecl
kubectl get csr isecl-scheduler.isecl -o jsonpath='{.status.certificate}' \
    | base64 --decode > server.crt
kubectl create configmap isecl-scheduler-certs --from-file=/tmp/k8s-certs/tls-certs --namespace isecl
```

### Installing isecl-helm charts

* Clone the repo
```shell
<repo clone>
cd <repo path>
```

#### Update `values.yaml` for Use Case chart deployments

Some assumptions before updating the `values.yaml` are as follows:
* The images are built on the build machine and images are pushed to a registry tagged with `release_version`(e.g:v4.0.0) as version for each image
* The NFS server and setup either using sample script or by the user itself
* The K8s non-managed cluster is up and running
* Helm 3 is installed

The `values.yaml` under use case charts needs to be updated for the following:
```yaml
# The below section can be used to override additional values defined under each of the dependent charts
cms:
  image:
    name: <user input> # Certificate Management Service image name

aas:
  image:
    name: <user input> # Authentication & Authorization Service image name

aas-manager:
  image:
    name: <user input> # Authentication & Authorization Manager image name

hvs:
  image:
    name: <user input> # Host Verification Service image name

ta: 
  image:
    name: <user input> # Trust Agent image name

global:
  controlPlaneHostname: <user input> # K8s control plane IP/Hostname
  
  config:
    globalAdminUsername: <user input> # Global Admin username for API access
    globalAdminPassword: <user input> # Global Admin password for API access
    installAdminUsername: <user input> # Install Admin username for installing services
    installAdminPassword: <user input> # Install Admin password for installing services

  image:
    registry: <user input> # The image registry where isecl images are pushed

  storage:
    nfs:
      server: <user input> # The NFS Server IP/Hostname
      path: /mnt/nfs_share/  # The path for storing persistent data on NFS (Default: /mnt/nfs_share/)
```

#### Use Case charts Deployment

```shell
cd usecases/
helm dependency update <use case chart folder>/
helm install <helm release name> <use case chart folder>/ --create-namespace -n isecl
```
> **Note:** If using a seprarate .kubeconfig file, ensure to provide the path using `--kubeconfig <.kubeconfig path>`

#### Individual Service/Agent Charts Deployment

```shell
cd services/
helm install <helm release name> <service chart folder>/ --create-namespace -n isecl 
```
> **Note:** If using a seprarate .kubeconfig file, ensure to provide the path using `--kubeconfig <.kubeconfig path>`

