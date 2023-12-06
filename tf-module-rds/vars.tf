variable "name" {
  default = "rds"
}
variable "env" {}
variable "subnets" {}
variable "tags" {}
variable "vpc_id" {}
variable "allow_db_cidr" {}
variable "engine_version" {}
variable "kms_arn" {}
variable "port_num" {
  default = 3306
}
variable "instance_class" {}
variable "instance_count" {}
