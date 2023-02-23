resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "master1" {
  ami = var.AMIS_master[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
  tags = {Name = "master1"}

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | K3S_NODE_NAME=k3s-Master-1 sh -s - server --token=dfXagzaueZM8Ye --cluster-init"
    ]
  }
  connection { 
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    }
  
}

resource "aws_instance" "master2" {
  ami = var.AMIS_master[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
  tags = {Name = "master2"}

  provisioner "remote-exec" {
    inline = [
      "sudo curl -sfL https://get.k3s.io | K3S_NODE_NAME=k3s-Master-2 sh -s - server --server https://${aws_instance.master1.private_ip}:6443  --token=dfXagzaueZM8Ye"

    ]
  }
  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    }

}

resource "aws_instance" "master3" {
  ami = var.AMIS_master[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
  tags = {Name = "master3"}

  provisioner "remote-exec" {
    inline = [
      "sudo curl -sfL https://get.k3s.io | K3S_NODE_NAME=k3s-Master-3 sh -s - server --server https://${aws_instance.master1.private_ip}:6443  --token=dfXagzaueZM8Ye"
    ]
  }
  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    }

}

resource "aws_instance" "worker1" {
  ami = var.AMIS_worker[var.AWS_REGION]
  instance_type = "c6g.medium"
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
  tags = {Name = "worker1"}

  provisioner "remote-exec" {
    inline = [
      "sudo curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION='v1.20.4+k3s1' K3S_NODE_NAME=k3s-Worker-1 sh -s - agent --server https://${aws_instance.master1.private_ip}:6443 --token=dfXagzaueZM8Ye"
    ]
  }
  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    }

}

resource "aws_instance" "worker2" {
  ami = var.AMIS_worker[var.AWS_REGION]
  instance_type = "c6g.medium"
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
  tags = {Name = "worker2"}

  provisioner "remote-exec" {
    inline = [
      "sudo curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION='v1.20.4+k3s1' K3S_NODE_NAME=k3s-Worker-2 sh -s - agent --server https://${aws_instance.master1.private_ip}:6443 --token=dfXagzaueZM8Ye"
    ]
  }
  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    }

}

resource "aws_instance" "worker3" {
  ami = var.AMIS_worker[var.AWS_REGION]
  instance_type = "c6g.medium"
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
  tags = {Name = "worker3"}

  provisioner "remote-exec" {
    inline = [
      "sudo curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION='v1.20.4+k3s1' K3S_NODE_NAME=k3s-Worker-3 sh -s - agent --server https://${aws_instance.master1.private_ip}:6443 --token=dfXagzaueZM8Ye"
    ]
  }
  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    }

}


resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow ssh  inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]

  }
}
