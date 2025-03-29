variable "project" {
  type    = string
  default = "expense"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "ssh_port" {
  type    = number
  default = 22
}

variable "https_port" {
  type    = number
  default = 443
}

variable "mysql_port" {
  type    = number
  default = 3306
}

variable "nodeport_start" {
  type    = number
  default = 30000
}

variable "nodeport_end" {
  type    = number
  default = 32767
}