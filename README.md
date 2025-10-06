# AutoGCP: Automated GCP Infrastructure Deployment with Terraform and YAML

This project streamlines the creation of Google Cloud Platform (GCP) infrastructure. Instead of writing complex Terraform code for each new environment, you simply define all your required resources in a single YAML file. An automation script then parses this file, generates the necessary Terraform configuration, and deploys the infrastructure.

This approach is based on the requirements outlined in the [Terraform_Auto_Intern_Project.md](Terraform_Auto_Intern_Project.md) document, which aimed to simplify and accelerate the setup of new GCP projects.

## Features

  * **YAML-Driven Infrastructure**: Define entire GCP environments—from projects and VPCs to VMs and Load Balancers—in a simple, human-readable YAML file.
  * **Modular & Reusable**: Built on a foundation of reusable Terraform modules for consistent and maintainable resource creation.
  * **Full Automation**: Python scripts handle the entire workflow: reading your config, generating Terraform variables, and running `apply` or `destroy`.
  * **CI/CD Integrated**: Includes a powerful GitHub Actions workflow that automates deployment and destruction based on git commit messages or manual triggers.
  * **Comprehensive Resource Support**: Easily provision a wide range of common GCP services.

---

## Supported GCP Resources

This framework supports the creation and management of the following GCP resources through their respective modules:

  * **GCP Project**: Creates a new project and links billing.
  * **VPC Network**: Provisions a Virtual Private Cloud.
  * **Subnets**: Creates subnets within the VPC.
  * **Routes**: Defines custom network routes.
  * **Firewall Rules**: Manages ingress/egress rules.
  * **Compute Instances**: Deploys virtual machines.
  * **Persistent Disks**: Creates standalone compute disks.
  * **Static IPs**: Reserves internal or external static IP addresses.
  * **Service Accounts**: Manages IAM service accounts.
  * **Cloud DNS**: Creates public or private DNS zones and record sets.
  * **Cloud Storage**: Provisions GCS buckets with versioning and labels.
  * **Load Balancers**: Sets up external and internal HTTP(S) load balancers.

---

## Project Structure

The repository is organized to separate configuration, automation logic, and Terraform modules.

```
.
├── Configs/
│   ├── project-01.yaml
│   └── project-02.yaml
├── main.tf
├── variables.tf
├── Modules/
│   ├── project/
│   ├── vpc/
│   ├── subnet/
│   │   ... (and other resource modules)
├── Scripts/
│   ├── deploy.py
│   ├── destroy.py
│   └── helper_functions.py
├── .github/workflows/
│   └── infrastructure-deploy.yml
├── README.md
└── README-CI.md
```

---

## Prerequisites

Before you begin, ensure you have the following installed and configured:

1.  **Terraform**: Version `1.6.0` or compatible.
2.  **Python**: Version `3.11` or compatible.
3.  **Python Dependencies**: Install the required `PyYAML` package.
    ```bash
    pip install pyyaml
    ```
4.  **Google Cloud SDK (`gcloud`)**: Authenticated to your GCP account.
5.  **GCP Authentication**: You must be authenticated for the scripts to work. The recommended method is to use Application Default Credentials (ADC):
    ```bash
    gcloud auth application-default login
    ```

---

## Configuration

All infrastructure is defined in a YAML file within the [Configs/](Configs/) directory. You can create a new file or modify an existing one like [project-01.yaml](Configs/project-01.yaml).

The file is structured with top-level keys that correspond to the Terraform modules used for deployment.

### Example: `Configs/project-01.yaml`

```yaml
project:
  project_name: "konecta-task9-gcp-project-3"
  project_id: "konecta-task9-gcp-project-id-3"
  billing_account: "XXXXXX-XXXXXX-XXXXXX"
  deletion_policy: "DELETE"
  labels:
    owner: intern
    environment: test
  apis:
    - compute.googleapis.com
    - iam.googleapis.com

vpc_name: "konecta-task9-vpc"

subnets:
  konecta-task9-pb-subnet:
    cidr: "10.0.1.0/24"
    region: "us-central1"
  konecta-task9-pv-subnet:
    cidr: "10.0.2.0/24"
    region: "us-central1"

firewall_rules:
  allow-ssh:
    protocol: "tcp"
    ports: ["22"]
    source_ranges: ["203.0.113.25/32"]

compute_instances:
  konecta-task9-pb-vm:
    machine_type: "e2-medium"
    zone: "us-central1-a"
    image: "debian-cloud/debian-12"
    network: "konecta-task9-vpc"
    subnetwork: "konecta-task9-pb-subnet"
    assign_public_ip: true
    tags: ["ssh", "web"]

# ... other resources like load_balancers, gcs_bucket, etc.
```

---

## How to Run Locally

You can deploy or destroy infrastructure directly from your local machine using the provided Python scripts.

### 1. Create Your Configuration

Create a new file (e.g., `my-project.yaml`) inside the [Configs/](Configs/) directory.

### 2. Deploy Infrastructure

Run the [deploy.py](Scripts/deploy.py) script, passing the path to your configuration file. The script will first run a `terraform plan` and then prompt you for confirmation before applying the changes.

```bash
# The script will prompt for a 'yes' or 'no'
python Scripts/deploy.py Configs/my-project.yaml
```

### 3. Destroy Infrastructure

To tear down all resources managed by a configuration, run the [destroy.py](Scripts/destroy.py) script. You will be prompted for confirmation twice: once for the Terraform destroy action and once to determine the destroy scope.

  - **Destroy Scope `modules`**: Runs `terraform destroy` but keeps the generated project folder.
  - **Destroy Scope `all`**: Runs `terraform destroy` and then deletes the generated project folder.

```bash
# The script will prompt for confirmation
python Scripts/destroy.py Configs/my-project.yaml
```

---

## CI/CD Automation

This project includes a GitHub Actions workflow for fully automated CI/CD. The workflow is triggered by pushes to the `main` branch or can be run manually. It parses commit messages to determine the action (`deploy`/`destroy`), target files, and approval status.

For a complete guide on commit message syntax, manual dispatch inputs, and troubleshooting, please see [README-CI.md](README-CI.md).

---
