variable "vpc_id" {
  type = string
}
variable "sg_name" {
  type        = string
  default     = "terraform_http"
}

variable "sg_description" {
  type        = string
  default     = "allowing http from nlp"
}
  

variable "instance_type" {
  type = string
}

variable "private_ec2_name" {
  type = string
}

variable "subnet_ids" {
  type = list
}