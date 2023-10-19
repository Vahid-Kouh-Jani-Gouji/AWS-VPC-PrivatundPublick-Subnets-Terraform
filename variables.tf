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
