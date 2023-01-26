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

variable "NLP_name" {
  type = string
  default = "Terraform-NLP"
}

variable "private_subnet_ids" {
  type = list 
}
