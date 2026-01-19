variable "security_group_id" {
  type = string
}
variable "load_balancer_sg_id" {
  type = string
}   
variable "vpc_id" {
  type = string
}
variable "public_subnets" {
  type = list(string)
}
variable "target_instance" {
  type = string
}

variable "alb_name" {
  type = string
    default = "application-load-balancer"
}