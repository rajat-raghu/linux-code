
variable "tag_id"{
    description =" say hi " 
}
variable "port" {
    description = "enter port number to be acessed"
    type = number
}

provider "aws"{
    region = "us-east-1"
    profile= "default"
}

resource "aws_instance" "trial"{
    ami = "ami-085925f297f89fce1"
    instance_type= "t2.micro"
    vpc_security_group_ids = [aws_security_group.sec.id]

    user_data = <<-EOF
                #!bin/bash
                echo"hello-w" >> index.html
                nohup busybox httpd -f -p "${var.port} &
                EOF
    
    
    tags = {
        a = "first"
        version = "v1" 
        b = var.tag_id
       # c=  aws_instance.trial.ami
    }
}


resource "aws_security_group" "sec" {
    name = "sec"
    ingress {
        from_port = var.port
        to_port = var.port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
  
}

#lifecycle {
#    create_before_destroy = true
#}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.example.id}"
  instance_id = "${aws_instance.trial.id}"
}

resource "aws_ebs_volume" "example" {

  availability_zone = "us-west-2a"
  size              = 10

  tags = {
    Name = "HelloWorld"
  }
}
output "port" {
    description = "this is the public port "
    value = aws_instance.trial.public_ip
}
