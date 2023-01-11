terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "vcn-for-oke" {
  source           = "ivandelic/cn-vcn/oci"
  version          = "1.0.1"
  compartment_ocid = var.compartment_ocid
  name             = var.vcn_name
  vcn_cidr         = var.vcn_cidr
  vcn_subnets      = var.vcn_subnets
}

module "oke" {
  source           = "ivandelic/cn-oke/oci"
  version          = "1.0.0"
  compartment_ocid = var.compartment_ocid
  k8s_version      = var.k8s_version
  name             = var.oke_name
  pools            = {
    pool-1 = {
      vm_image_name = "Oracle-Linux-7.9-2022.10.04-0"
    }
  }
  subnet_id_endpoint = module.vcn-for-oke.subnets["k8s-endpoint-api"].id
  subnet_id_lb       = module.vcn-for-oke.subnets["load-balancer"].id
  subnet_id_node     = module.vcn-for-oke.subnets["worker-node"].id
  vcn_id             = module.vcn-for-oke.vcn_id
}
