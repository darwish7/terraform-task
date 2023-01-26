variable "subnet_cidr_block" {
    type = map
}

variable "vpc-id" {
  type = string
}


variable "cidr_block_public_source" {
  type = string
}

variable "natgw_name" {
  type        = string
  default     = "natgw"
}

variable "natgw_subnet" {
  type        = string
}

