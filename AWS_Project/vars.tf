variable "instance_type" {
  default = "t3.small"
}

variable "desired_capacity" {
  default = 2
}

variable "max_size" {
  default = 10
}

variable "min_size" {
  default = 2
}

variable "app_port" {
  default = 80
}

variable "listener_priority" {
  default = 100
}

variable "dns_name" {
  default = "dev"
}
