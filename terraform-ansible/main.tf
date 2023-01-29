#defining the provider block
provider "aws" {
  region = "eu-west-1"
}

# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "ec2-keypair"
  public_key = tls_private_key.key_pair.public_key_openssh
}

# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}

# RHEL 8.5
data "aws_ami" "rhel_8_5" {
  most_recent = true

  owners = ["309956199498"] // Red Hat's Account ID

  filter {
    name   = "name"
    values = ["RHEL-8.5*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

# Define the security group for the Linux server
resource "aws_security_group" "aws-sg" {
  name        = "ec2-sg"
  description = "Allow incoming HTTP connections"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.aws_az
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

# Define the public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Assign the public route table to the public subnet
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

#aws instance creation
resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.rhel_8_5.id
  instance_type               = "t2.medium"
  security_groups             = [aws_security_group.aws-sg.id]
  key_name                    = aws_key_pair.key_pair.key_name
  subnet_id                   = aws_subnet.public-subnet.id
  associate_public_ip_address = true
  source_dest_check           = false

}

#IP of aws instance retrieved
output "output_ip" {
  value = aws_instance.ec2_instance.public_ip
}

#IP of aws instance copied to a file ip.txt in local system
resource "local_file" "ip" {
  content  = aws_instance.ec2_instance.public_ip
  filename = "ip.txt"
}

#ebs volume created
resource "aws_ebs_volume" "ebs" {
  availability_zone = aws_instance.ec2_instance.availability_zone
  size              = 1
}

#ebs volume attatched
resource "aws_volume_attachment" "ebs_attachment" {
  device_name  = "/dev/xvdb"
  volume_id    = aws_ebs_volume.ebs.id
  instance_id  = aws_instance.ec2_instance.id
  force_detach = false
}


#device name of ebs volume retrieved
output "output_device_name" {
  value = aws_volume_attachment.ebs_attachment.device_name
}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook -u "ec2-user" --private-key $private_key_path -i $public_ip $provisoner
    EOT

    environment = {
      public_ip  = "${aws_instance.ec2_instance.public_ip}"
      provisoner = "/workspaces/uipath-robot-kubernetes/terraform-ansible/ansible/volume.yml"
      private_key_path = "/workspaces/uipath-robot-kubernetes/terraform-ansible/ec2-keypair.pem"
      # private_key_path = var.private_key_path
      # user             = "azureuser"
    }
  }
  depends_on = [aws_volume_attachment.ebs_attachment]
}

# #connecting to the Ansible control node using SSH connection
# resource "null_resource" "nullremote1" {
#   depends_on = [aws_instance.ec2_instance]
#   connection {
#     type     = "ssh"
#     user     = "root"
#     password = var.password
#     host     = var.host
#   }
#   #copying the ip.txt file to the Ansible control node from local system
#   provisioner "file" {
#     source      = "ip.txt"
#     destination = "/root/ansible_terraform/aws_instance/ip.txt"
#   }
# }


# #connecting to the Linux OS having the Ansible playbook
# resource "null_resource" "nullremote2" {
#   depends_on = [aws_volume_attachment.ebs_attachment]
#   connection {
#     type     = "ssh"
#     user     = "root"
#     password = var.password
#     host     = var.host
#   }
#   #command to run ansible playbook on remote Linux OS
#   provisioner "remote-exec" {

#     inline = [
#       "cd /root/ansible_terraform/aws_instance/",
#       "ansible-playbook instance.yml"
#     ]
#   }
# }
