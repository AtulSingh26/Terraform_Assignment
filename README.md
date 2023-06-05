# Terraform Assignment

## Problem Statement: 
```
● Write Terraform script to create a custom VPC and deploy two EC2 VMs on AWS
using Terraform.
● The code should be broken into three different parts:  
    1. Networking (define the VPC and all of its components)
    2. SSH-Key (dynamically create an SSH-key pair for connecting to VMs)
    3. EC2 (deploy a VM in the public subnet, and deploy another VM in a
    private subnet)
    4. NGINX should be accessed for all the internet. 
● Automate Terraform Deployment with Jenkins Pipelines

```

### Given below are some steps 

#### 1. Define the VPC

This step creates a custom VPC using the aws_vpc resource. The VPC is given a CIDR block of 10.0.0.0/16, which allows for a range of IP addresses within the VPC. The tags block is used to assign a name tag to the VPC for identification.

Explaination of the  resources: 

`resource`: This keyword indicates that the following code defines a resource.  
`aws_vpc`: This identifier specifies that the resource is an AWS VPC.  
`CUSTOM_VPC`: This is the name of the resource.  
`cidr_block`: This property specifies the IP address range for the VPC.  
`tags`: This property specifies a list of tags to associate with the VPC.  
`Name`: This tag key specifies the name of the VPC.  

 The code block for this is present in `vpc.tf`.
 
 
#### Output:  
<img width="867" alt="Screenshot 2023-06-05 at 11 58 03 AM" src="https://github.com/AtulSingh26/Terraform_Assignment/assets/122472996/37e06880-2994-41a4-9b2c-1ad997ca454e">


#### 2. Define the public subnet

- In this step, the aws_subnet resource is used to create a public subnet within the VPC. It is associated with the VPC using the vpc_id parameter. 
- The subnet is given a CIDR block of 10.0.1.0/24, which allows for a range of IP addresses within the subnet. The subnet is placed in the us-east-1a availability zone. 
- The map_public_ip_on_launch parameter is set to true, indicating that instances launched in this subnet should be assigned a public IP address automatically. 

Explaination of the resources: 

`resource`: This keyword indicates that the following code defines a resource.  
`aws_subnet`: This identifier specifies that the resource is an AWS subnet.  
`public_subnet`: This is the name of the resource.  
`vpc_id`: This property specifies the ID of the VPC that the subnet belongs to.  
`cidr_block`: This property specifies the IP address range for the subnet.  
`availability_zone`: This property specifies the availability zone where the subnet is located.  
`map_public_ip_on_launch`: This property specifies whether or not to assign a public IP address to instances launched in the subnet.  
`tags`: This property specifies a list of tags to associate with the subnet.  
`Name`: This tag key specifies the name of the subnet.  

 The code block for this is present in `subnets.tf`.

#### 3. Define the private subnet

- Similar to the previous step, this step creates a private subnet within the VPC using the aws_subnet resource. The subnet is associated with the VPC using the vpc_id parameter. 
- It is given a CIDR block of 10.0.2.0/24 and placed in the us-east-1b availability zone. Instances launched in this subnet will not be assigned a public IP address.

Explanation of the resources:

`resource`: This keyword indicates that the following code defines a resource.  
`aws_subnet`: This identifier specifies that the resource is an AWS subnet.  
`private_subnet`: This is the name of the resource.  
`vpc_id`: This property specifies the ID of the VPC that the subnet belongs to.  
`cidr_block`: This property specifies the IP address range for the subnet.  
`availability_zone`: This property specifies the availability zone where the subnet is located.   
`tags`: This property specifies a list of tags to associate with the subnet.  
`Name`: This tag key specifies the name of the subnet.    

 
 
 The code block for this is present in `subnets.tf`.
 
 
#### Output: 

<img width="1003" alt="Screenshot 2023-06-05 at 11 57 28 AM" src="https://github.com/AtulSingh26/Terraform_Assignment/assets/122472996/d472bc98-ab52-4bb9-8432-57d53b8082c5">


#### 4. Generate and Create SSH key pair

- This step generates an RSA SSH key pair using the tls_private_key resource. The key pair will be used for SSH access to the EC2 instances.
- In this step, an AWS key pair is created using the aws_key_pair resource. The key_name parameter specifies the name of the key pair, which is set to "ssh-key". 
- The public key generated in the previous step (tls_private_key.ssh_key.public_key_openssh) is assigned to the public_key parameter. This key pair will be associated with the instances for SSH access.

Explaination for the resouces: 
`resource`: This keyword indicates that the following code defines a resource.  
`tls_private_key`: This identifier specifies that the resource is a TLS private key.  
`SSH_KEY`: This is the name of the resource.  
`algorithm`: This property specifies the algorithm used to generate the private key. In this case, the algorithm is RSA.  
`aws_key_pair`: This identifier specifies that the resource is an AWS key pair.  
`ssh_key_pair`: This is the name of the resource.  
`key_name`: This property specifies the name of the key pair.  
`public_key`: This property specifies the public key of the key pair. The public key is stored in the `tls_private_key.SSH_KEY.public_key_openssh` variable.  

 The code block for this is present in `ssh.tf`.


#### Output: 

<img width="709" alt="Screenshot 2023-06-05 at 11 58 15 AM" src="https://github.com/AtulSingh26/Terraform_Assignment/assets/122472996/f8c2d5d5-28a6-4ff4-a37f-6fd2cae5277e">

<img width="680" alt="Screenshot 2023-06-05 at 11 56 59 AM" src="https://github.com/AtulSingh26/Terraform_Assignment/assets/122472996/59015a80-e2da-4b26-a90d-b116fee09749">




####  5.Create the public EC2 instance

- This step creates an EC2 instance in the public subnet using the aws_instance resource. The ami parameter specifies the Amazon Machine Image (AMI) ID of the instance. 
- The instance_type parameter determines the instance size, set to "t2.micro" in this case. The key_name parameter specifies the key pair to associate with the instance for SSH access. 
- The subnet_id parameter references the ID of the public subnet created earlier (aws_subnet.public_subnet.id). 
- The provisioner block defines a remote-exec provisioner, which runs a set of inline commands on the instance after it is launched. In this case, it updates the package repository, installs Nginx, and starts the Nginx service on the instance.

Explaination for the resources: 
`resource "aws_instance" "PUBLIC_VM"` defines the resource block.  
`ami` specifies the AMI ID for the instance.  
`instance_type` specifies the type of instance to create.  
`key_name` specifies the name of the SSH key pair to use to connect to the instance.  
`subnet_id` specifies the ID of the subnet in which to create the instance.  
`tags` specifies tags to associate with the instance.   
`provisioner "remote-exec"` specifies a provisioner that will be used to configure the instance after it is created.  
`inline` specifies a list of commands that will be run by the provisioner. 

 The code block for this is present in `ec2.tf`.


#### Output: 

<img width="1018" alt="Screenshot 2023-06-05 at 11 56 30 AM" src="https://github.com/AtulSingh26/Terraform_Assignment/assets/122472996/00c2464a-c967-4517-b326-25ac2297408f">




####  6.Create the private EC2 instance

- Similar to the previous step, this step creates an EC2 instance in the private subnet. It uses the specified AMI, instance type, SSH key pair, and subnet ID. 
- The provisioner block runs inline commands to update packages, install Nginx, and start the Nginx service on the instance. 

Explanation of the resouces:  
`resource "aws_instance" "PRIVATE_VM"`: This defines the resource that will be created. In this case, it is an AWS EC2 instance.
`ami`: This property specifies the AMI that will be used to create the instance.
`instance_type`: This property specifies the instance type of the instance.
`key_name`: This property specifies the name of the key pair that will be used to access the instance.
`subnet_id`: This property specifies the ID of the subnet in which the instance will be created.
`tags`: This property specifies the tags that will be applied to the instance.
`provisioner "remote-exec"`: This provisioner specifies that the instance will be provisioned using the remote-exec provisioner.
`inline`: This property specifies the commands that will be run to provision the instance.


The code block for this is present in `ec2.tf`.


#### Output: 

<img width="1015" alt="Screenshot 2023-06-05 at 11 55 30 AM" src="https://github.com/AtulSingh26/Terraform_Assignment/assets/122472996/26760be4-dca6-4282-94ad-f378356245b1">


#### These steps, when executed with Terraform, create a custom VPC, subnets, SSH key pair, and EC2 instances in AWS. The provisioner blocks install and start Nginx on both instances.


# Output of CI/CD :   
[CLICK HERE](https://github.com/AtulSingh26/Terraform_Assignment/actions)
