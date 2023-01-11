variable "region" {
  type = string
}
variable "tenancy_ocid" {
  type = string
}
variable "compartment_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}
variable "fingerprint" {
  type = string
}
variable "private_key_path" {
  type = string
}

variable "vcn_name" {
  type = string
}
variable "vcn_cidr" {
  type = string
}
variable "vcn_subnets" {
  default = null
  type = map(object({
    cidr_block = string
    is_public  = bool
    rt_rules = optional(list(object({
      description         = string
      destination         = string
      destination_type    = string
      network_entity_type = string
      network_entity_id   = optional(string)
    })))
    sl_rules = object({
      egress_security_rules = optional(list(object({
        destination      = string
        protocol         = string
        description      = optional(string)
        destination_type = optional(string)
        stateless        = optional(bool)
        tcp_options = optional(object({
          min = number
          max = number
        }))
        udp_options = optional(object({
          min = number
          max = number
        }))
        icmp_options = optional(object({
          type = number
          code = optional(number)
        }))
      })))
      ingress_security_rules = optional(list(object({
        source      = string
        protocol    = string
        description = optional(string)
        source_type = optional(string)
        stateless   = optional(bool)
        tcp_options = optional(object({
          min = number
          max = number
        }))
        udp_options = optional(object({
          min = number
          max = number
        }))
        icmp_options = optional(object({
          type = number
          code = optional(number)
        }))
      })))
    })
  }))
}

variable "oke_name" {
  type = string
}
variable "k8s_version" {
  type = string
}