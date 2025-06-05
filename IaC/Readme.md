# IaC: Multi-Cloud Kubernetes & Docker Swarm Infrastructure

This directory contains Terraform code to provision infrastructure for deploying applications using:
- **Managed Kubernetes**: AWS (EKS), Google Cloud (GKE), Azure (AKS)
- **Docker Swarm**: On a cluster of cloud instances in AWS, GCP, and Azure

The goal is a reusable, general-purpose starting point for real-world multi-cloud DevOps and CI/CD pipelines.

---

## Structure

```plaintext
IaC/
├── modules/
│   ├── aws/
│   │   ├── eks/
│   │   └── swarm/
│   ├── gcp/
│   │   ├── gke/
│   │   └── swarm/
│   └── azure/
│       ├── aks/
│       └── swarm/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
└── README.md
```

- **modules/**: Reusable modules for each platform and service
- **environments/**: Per-environment customizations/overrides
- **main.tf**: Top-level infrastructure definition (calls modules)
- **variables.tf**: Input variables for customization
- **outputs.tf**: Useful outputs (kubeconfig, endpoints, etc.)
- **providers.tf**: Cloud provider setup

---

## Supported Platforms

- **Kubernetes**:
    - AWS EKS (`modules/aws/eks`)
    - GCP GKE (`modules/gcp/gke`)
    - Azure AKS (`modules/azure/aks`)
- **Docker Swarm**:
    - AWS (`modules/aws/swarm`)
    - GCP (`modules/gcp/swarm`)
    - Azure (`modules/azure/swarm`)

---

## Usage

### 1. Prerequisites

- [Terraform](https://www.terraform.io/downloads)
- Cloud credentials for AWS, GCP, and/or Azure
- [kubectl](https://kubernetes.io/docs/tasks/tools/) & [docker](https://docs.docker.com/get-docker/) (for client use)

### 2. Initialize Terraform

```sh
cd IaC
terraform init
```

### 3. Select or Configure Your Environment

- Use or create a directory under `environments/` (dev, staging, prod, etc.)
- Override variables as needed.

### 4. Plan and Apply

```sh
terraform plan -var-file="environments/dev/terraform.tfvars"
terraform apply -var-file="environments/dev/terraform.tfvars"
```

### 5. Grab Kubeconfig / Swarm Manager Info

- Run `terraform output` to get connection info and credentials for clusters.

---

## How Modules Work

Each `swarm/` or Kubernetes module provisions a cluster in the respective cloud, handling network, security, compute, and bootstrap.

- **Kubernetes modules** output `kubeconfig` for direct use with `kubectl`.
- **Swarm modules** output manager IP and the join command for worker nodes.

---

## Example: main.tf for Docker Swarm in AWS, GCP, and Azure

Below are example `main.tf` files for deploying a Docker Swarm cluster in each major cloud provider.  
**Note:** You must supply required variables (see each module's `variables.tf`).

---


## Security & Best Practices

- Use remote state backends for production (e.g., S3, GCS, Azure Storage)
- Use least-privilege IAM roles and service accounts
- Secure your SSH keys and kubeconfigs
- Parameterize instance counts and sizes for flexibility
- Use cloud-init or provisioners for bootstrap only (not ongoing config)

---

## Health Check Endpoint Example

Every app deployed to these clusters should implement a health endpoint for readiness/liveness, e.g.:

**Node.js**
```javascript
app.get('/healthz', (req, res) => res.status(200).send('OK'));
```
**Python / Flask**
```python
@app.route('/healthz')
def health():
    return "OK", 200
```
**Go**
```go
http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("OK"))
})
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
