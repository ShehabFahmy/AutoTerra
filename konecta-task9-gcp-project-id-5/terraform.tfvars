project = {
  "project_name": "konecta-task9-gcp-project-5",
  "project_id": "konecta-task9-gcp-project-id-5",
  "organization_id": null,
  "billing_account": "XXXXXX-XXXXXX-XXXXXX",
  "deletion_policy": "DELETE",
  "labels": {
    "owner": "intern",
    "environment": "test"
  },
  "apis": [
    "compute.googleapis.com",
    "iam.googleapis.com"
  ]
}
vpc_name = "konecta-task9-vpc"
routes = {
  "konecta-task9-vpc-default-route": {
    "dest_range": "0.0.0.0/0",
    "next_hop_gateway": "default-internet-gateway",
    "name": "konecta-task9-vpc-default-route"
  }
}
subnets = {
  "konecta-task9-pb-subnet": {
    "cidr": "10.0.1.0/24",
    "region": "us-central1",
    "name": "konecta-task9-pb-subnet"
  },
  "konecta-task9-pv-subnet": {
    "cidr": "10.0.2.0/24",
    "region": "us-central1",
    "name": "konecta-task9-pv-subnet"
  }
}
firewall_rules = {
  "allow-ssh": {
    "protocol": "tcp",
    "ports": [
      "22"
    ],
    "source_ranges": [
      "203.0.113.25/32"
    ],
    "name": "allow-ssh"
  },
  "allow-http": {
    "protocol": "tcp",
    "ports": [
      "80"
    ],
    "source_ranges": [
      "0.0.0.0/0"
    ],
    "name": "allow-http"
  }
}
compute_disks = {
  "konecta-task9-disk1": {
    "zone": "us-central1-a",
    "size_gb": 5,
    "type": "pd-standard",
    "name": "konecta-task9-disk1"
  },
  "konecta-task9-disk2": {
    "zone": "us-central1-a",
    "size_gb": 10,
    "type": "pd-standard",
    "name": "konecta-task9-disk2"
  }
}
static_ips = {
  "konecta-task9-global-ip-frontend": {
    "address_type": "EXTERNAL",
    "region": null,
    "description": "Global static IP for frontend load balancer",
    "name": "konecta-task9-global-ip-frontend"
  },
  "konecta-task9-regional-ip-backend": {
    "address_type": "INTERNAL",
    "region": "us-central1",
    "subnetwork": "default",
    "purpose": "GCE_ENDPOINT",
    "description": "Regional internal IP for backend VM",
    "name": "konecta-task9-regional-ip-backend"
  }
}
service_accounts = {
  "frontend-sa": {
    "display_name": "Frontend Service Account",
    "description": "Used by the frontend GKE service",
    "name": "frontend-sa"
  },
  "backend-sa": {
    "display_name": "Backend Service Account",
    "description": "Used by backend compute instances",
    "name": "backend-sa"
  }
}
cloud_dns_zones = {
  "example-zone": {
    "dns_name": "example.com.",
    "description": "Public DNS zone for example.com",
    "record_sets": [
      {
        "name": "www.example.com.",
        "type": "A",
        "ttl": 300,
        "rrdatas": [
          "34.123.56.78"
        ]
      },
      {
        "name": "mail.example.com.",
        "type": "MX",
        "ttl": 3600,
        "rrdatas": [
          "10 mail.example.com."
        ]
      }
    ],
    "name": "example-zone"
  },
  "internal-zone": {
    "dns_name": "internal.example.com.",
    "description": "Private DNS zone for internal services",
    "record_sets": [],
    "name": "internal-zone"
  }
}
gcs_bucket = {
  "name": "konecta-task9-bucket",
  "location": "US",
  "versioning": true,
  "labels": {
    "env": "dev"
  }
}
compute_instances = {
  "konecta-task9-pb-vm": {
    "machine_type": "e2-medium",
    "zone": "us-central1-a",
    "image": "debian-cloud/debian-12",
    "network": "konecta-task9-vpc",
    "subnetwork": "konecta-task9-pb-subnet",
    "assign_public_ip": true,
    "tags": [
      "ssh",
      "web"
    ],
    "metadata": {
      "startup-script": "echo Hello from Terraform > /var/tmp/startup.txt"
    },
    "name": "konecta-task9-pb-vm"
  },
  "konecta-task9-pv-vm": {
    "machine_type": "e2-medium",
    "zone": "us-central1-a",
    "image": "debian-cloud/debian-12",
    "network": "konecta-task9-vpc",
    "subnetwork": "konecta-task9-pv-subnet",
    "assign_public_ip": false,
    "name": "konecta-task9-pv-vm"
  }
}
load_balancers = {
  "external-lb": {
    "protocol": "HTTP",
    "internal": false,
    "frontend_port": 80,
    "backend_port": 8080,
    "health_check_port": 8080,
    "instance_group_name": "frontend-group",
    "instance_group_zone": "us-central1-a",
    "instances": [
      "konecta-task9-pb-vm"
    ],
    "name": "external-lb"
  },
  "internal-lb": {
    "protocol": "HTTP",
    "internal": true,
    "frontend_port": 8080,
    "backend_port": 8080,
    "health_check_port": 8080,
    "instance_group_name": "backend-group",
    "instance_group_zone": "us-central1-a",
    "instances": [
      "konecta-task9-pv-vm"
    ],
    "name": "internal-lb"
  }
}
