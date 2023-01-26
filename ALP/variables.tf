variable "sg_name" {
  type        = string
  default     = "terraform_http_ALP"
}

variable "sg_description" {
  type        = string
  default     = "allowing public access to ALP"
}

variable "tg_name" {
  type        = string
  default     = "terraform-target-group"
}

variable "vpc_id" {
  type        = string
}

variable "tg_ec2_ids" {
  type = list
}

variable "ALP_name" {
  type = string
  default = "Terraform-ALP"
}

variable "public_subnet_ids" {
  type = list 
}
