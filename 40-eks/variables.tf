variable "project" {
  type    = string
  default = "expense"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "public_key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/AhjY1D0LzhkAUZFgmtIJFgFGBE0/3m+TP/o+OLPVnqWhlnVhVDJISs5w4BVRgfMYkuY/uH5rgLJf2nkXJm0Toz0tT9S3rteM8c19JbCD8XDe6hIAb2fOLEkzSBD3JSz0byTfaj1EtCdqkFkvUgwKrFGNLbKyPsqjeppTFZmUwxBB9pV+FebyNU9M6raOLtTcnh7ogtAtIWmu3ToYsiC4374OdjrJtpWS+IRTNhqgc9w2zvOOXgurPf74+cnyjpE75P4+GOevVL4FKQDSF6L9akCF/sfoLjhsgWm2xbwL2ZNdYbZjnGV57qKTCUG49HnxKF8wDHqlenQxizJ1bOSCnbK8/QTH6mThV82oaSoYCkbTPjsp0qeS9QeRwNmgn0vX8p+qG5r/Brs0LPhAXwpITkddYLkA+a3yPJcv7/l7Fp05edpNuAtRtBsbed7HLKkb6pWHqEudBNJfI3qpbTEvXn3n3ndN6kII3+rg5c/IWJLTVF9pINy5U/mcxJRQ36M= babbu@pop-os"
}