variable "vpc_id" {
  type = string
}
variable "sg_name" {
  type        = string
  default     = "terraform_http_ssh_ec2"
}

variable "sg_description" {
  type        = string
  default     = "allowing public access to ALP"
}
  

variable "instance_type" {
  type = string
}

variable "public_ec2_name" {
  type = string
}

variable "subnet_ids" {
  type = list
}
variable "inline-provisioner-remote-exec" {
  type = list
}