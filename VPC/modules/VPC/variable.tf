variable "vpc_cidr" { type = string }
variable "public_subnets" { 
    type = list(string) 
default = [ "PublicSubnet1", "PublicSubnet2" ]
}
variable "private_subnets" { 
    type = list(string) 
    default = [ "PrivateSubnet1", "PrivateSubnet2" ]
    }
variable "azs" { type = list(string) }
