resource "aws_instance" "this" {
  count = length(var.ec2_names)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
   tags = {
    Name = var.ec2_names[count.index]
  }
}
