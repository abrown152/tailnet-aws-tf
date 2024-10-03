# Terraform AWS Infrastructure


This Terraform project automates the provisioning of two EC2 instances on AWS to serve as a Tailnet device and subnet router, including creating an SSH key pair and configuring the remote backend to work with Terraform Cloud. 


## Prerequisites


Before running this Terraform project, make sure you have the following prerequisites:


- **Terraform CLI**: [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- **AWS Account**: You'll need an AWS account with programmatic access. You must create an AWS Access Key and Secret Key for the IAM user with sufficient permissions to create EC2 instances and key pairs.
- **Terraform Cloud Account**: You must have a Terraform Cloud account and an organization/workspace setup to use the remote backend functionality.
  
## AWS Credentials


To authenticate with AWS, ensure that your AWS credentials are available. You can provide credentials via:


1. **Environment Variables**:
   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key-id"
   export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
   
2. **AWS CLI Configuration**:
   Run `aws configure` to set up your AWS credentials locally.


## Setup Instructions


### Step 1: Clone the Repository
Clone this repository to your local machine:


```bash
git clone https://github.com/abrown152/tailnet-aws-tf.git
cd tailnet-aws-tf
```


### Step 2: Update Terraform Backend Configuration
The Terraform configuration is set to use **Terraform Cloud** as the backend. Update the backend configuration in `main.tf` to match your Terraform Cloud organization and workspace:


```hcl
terraform {
  backend "remote" {
    organization = "your-organization-name"


    workspaces {
      name = "your-workspace-name"
    }
  }
}
```


Make sure you have authenticated with Terraform Cloud by running:


```bash
terraform login
```


### Step 3: Initialize Terraform


Run the following command to initialize the project, which will download required providers and set up the backend:


```bash
terraform init
```


### Step 4: Create an SSH Key Pair


The project automatically creates an SSH key pair to access the EC2 instance. Update the key pair name in the `main.tf` file if necessary:


```hcl
resource "aws_key_pair" "key" {
  key_name   = "tailnet-aws-tf-key"   # Change the name if needed
}
```


### Step 5: Plan and Apply


To preview the changes Terraform will make, run:


```bash
terraform plan
```


To apply the changes and create the AWS resources, run:


```bash
terraform apply
```


Type `yes` to confirm the apply.


### Step 6: Accessing the EC2 Instance


After the infrastructure is created, you can SSH into the EC2 instance using the private key that was generated.


```bash
ssh -i tailnet-aws-tf-key.pem ec2-user@<EC2_PUBLIC_IP>
```


Replace `<EC2_PUBLIC_IP>` with the public IP address of your EC2 instance, which you can find in the output of the Terraform apply command.


## Variables


This project uses the following configurable variables in `variables.tf`:


| Name              | Default Value        | Description                                              |
| ----------------- | -------------------- | -------------------------------------------------------- |
| `aws_region`      | `us-east-2`           | The AWS region where the resources will be created.       |
| `instance_type`   | `t2.micro`            | The EC2 instance type.                                   |
| `key_name`        | `tailnet-aws-tf-key`  | The name of the SSH key pair used to access the instance. |


You can customize these variables by creating a `terraform.tfvars` file or passing them directly with the `-var` flag when running `terraform plan` or `terraform apply`.


## Cleaning Up


To destroy the resources created by this project and avoid incurring future costs, run the following command:


```bash
terraform destroy
```


Type `yes` to confirm the destroy.
