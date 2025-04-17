# ☁️ Terraform AWS Infra – Production-Ready Web App Setup

Yo! 👋

This repo sets up a **production-grade AWS infrastructure** for a classic multi-tier web application using **Terraform**. It’s modular, scalable, and built to keep your app humming along smoothly with monitoring and autoscaling baked in.

---

## 🧱 What’s Inside?

We’re talkin’ full-stack infra vibes here:

- 🔒 **VPC** – Isolated networking with public/private subnets, NAT, IGW, the works.
- 🖥️ **EC2** – App servers (Auto Scaling ready) in private subnets.
- 🌐 **ALB** – Application Load Balancer to handle traffic like a boss.
- 📈 **Auto Scaling Groups** – Your app grows (or shrinks) with demand.
- 🛢️ **RDS** – Managed PostgreSQL/MySQL in private subnets.
- 👀 **CloudWatch** – Metrics, logs, and alarms to keep an eye on things.
- 🧩 **Modular Architecture** – Everything split into clean, reusable HCL modules.

---

## 🚀 Quick Start

> **Prereqs:**
> - Terraform v1.3+
> - AWS CLI configured
> - An S3 bucket + DynamoDB table for remote state (you’ll need to set this up separately)

```bash
git clone https://github.com/your-user/terraform-prod-webapp.git
cd terraform-prod-webapp

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Launch it!
terraform apply
```
☕️ Grab a coffee while AWS spins everything up.

## 🗂️ Directory Structure

```bash
.
├── main.tf                # Root config - wires up the modules
├── variables.tf           # All input vars
├── outputs.tf             # Outputs you’ll actually use
├── modules/               # Reusable chunks of infra goodness
│   ├── vpc/
│   ├── ec2/
│   ├── alb/
│   ├── rds/
│   ├── autoscaling/
│   └── cloudwatch/
└── environments/
    └── prod/              # Env-specific configs (can add staging/dev)
```
## 🛠️ Customizing
Need to scale bigger? Swap DB engines? Use custom AMIs? No problem — just tweak the vars in your prod/ folder or the module configs.

## 🔐 Security Notes
- EC2 instances are in private subnets, accessed via a bastion or SSM.

- RDS is not publicly accessible.

- ALB handles HTTPS termination (use ACM certs).

- IAM roles/policies are tight — adjust if needed.

## 📊 Monitoring & Logs
- CloudWatch Alarms: CPU, disk, memory (via custom metrics if needed)

- CloudWatch Logs: App logs and system logs via EC2 log agents

- Optional: Plug into an ELK stack or third-party monitoring if needed.

## 💸 Cost Considerations
This is prod-level infra — not free tier friendly 😅
Make sure you understand the services you're spinning up (especially RDS and ALB) to avoid surprises.

## 🧼 Tear It Down (when you're done)

```bash
terraform destroy
```

## 🙋‍♀️ Gotchas / Tips
- Remote state is your friend. Don’t run this without it in prod.

- Want to test changes? Use a staging or dev environment under environments/

- Use terraform fmt and terraform validate before pushing changes.

## 📬 Contact
Found a bug or got questions? Open an issue or ping me.

## Cheers 🍻

— Hasnat, DevOps enthusiast
