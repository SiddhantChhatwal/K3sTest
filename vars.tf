variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_REGION"{
  default = "ap-south-1"
}

variable "AMIS_master" {
  type = map(string)
  default = {
    ap-south-1 = "ami-0f2e255ec956ade7f"
      }
}
variable "AMIS_worker" {
  type = map(string)
  default = {
    ap-south-1 = "ami-08795883c7b4b7140"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
} 

variable "INSTANCE_USERNAME"{
  default = "ubuntu"
}


