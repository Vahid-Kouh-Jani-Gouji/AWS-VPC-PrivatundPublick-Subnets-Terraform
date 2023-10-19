variable "region" {
  type    = string         # Welcher Datentyp ist die Variable?
  default = "eu-central-1" # Welchen Wert hat die Variable, wenn nichts angegeben wird?
}

variable "vzs" {
  description = "Variable Zone"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

}

variable "vpc_cidr" {
  type        = string
  description = "vpc segement"
  default     = "10.0.0.0/16"
}


variable "subnet_cidr" {
  description = "subnet segement"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
