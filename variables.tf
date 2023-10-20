variable "region" {
  type    = string         # Welcher Datentyp ist die Variable?
  
}

variable "vzs" {
  description = "available Zone"
  type        = list(string)


}

variable "vpc_cidr" {
  type        = string
  description = "vpc segement"
  
}


variable "subnet_cidr" {
  description = "subnet segement"
  type        = list(string)
  
}

variable "ec2_ami" {
  description = "Amazon machine Image"
  type = string
  
}

variable "instance_type" {
  description = "EC2 Type"
  type = string
  
}
