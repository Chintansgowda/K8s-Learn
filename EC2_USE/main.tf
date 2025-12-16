data "aws_ami" "myami" {
    most_recent = true


    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] 
    }

    owners = ["099720109477"]  # Canonical
  
}

resource "aws_instance" "myec2" {
    
    ami = data.aws_ami.myami.id
    instance_type = "t2.medium"
    key_name = "nv-login-aws"
    user_data = file("kind.sh")

    root_block_device {
      volume_size = 30
    }

    tags = {
      Name = "aws-ec2"
      env = "dev"
    }
  
}