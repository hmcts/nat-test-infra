variable "env" {
  type    = string
  default = "sbox"
}

variable "product" {
  type    = string
  default = "hub"
}

variable "component" {
  type = string
}

variable "builtFrom" {
  type    = string
  default = "terraform - but manually!"
}

variable "vnet_address_space" {
  type = string
}

variable "allowed_source_address_prefix" {
  type = string
}

variable "hub_vnet_name" {
  type    = string
  default = "hmcts-hub-sbox-int"
}

variable "hub_resource_group_name" {
  type    = string
  default = "hmcts-hub-sbox-int"
}
