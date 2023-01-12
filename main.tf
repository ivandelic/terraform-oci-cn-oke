terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

data "oci_core_images" "oke_images" {
  for_each       = var.pools != null ? var.pools : {}
  compartment_id = var.compartment_ocid
  display_name   = each.value.vm_image_name
}

resource "oci_containerengine_cluster" "containerengine_cluster" {
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.k8s_version
  name               = format("%s%s", "oke-", var.name)
  vcn_id             = var.vcn_id
  cluster_pod_network_options {
    cni_type = var.cni_type
  }
  defined_tags = var.oke_defined_tags
  endpoint_config {
    is_public_ip_enabled = var.is_api_endpoint_public
    subnet_id            = var.subnet_id_endpoint
  }
  image_policy_config {
    is_policy_enabled = var.is_image_verification_enabled
    dynamic "key_details" {
      for_each = var.is_image_verification_enabled == true ? [1] : []
      content {
        kms_key_id = var.image_verification_key_id
      }
    }
  }
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = var.is_dashboard_enabled
      is_tiller_enabled               = false # Tiller is deprecated in OKE and removed from Helm 3
    }
    admission_controller_options {
      is_pod_security_policy_enabled = false # Disabling by default since PSP is deprecated since v1.21.
    }
    kubernetes_network_config {
      pods_cidr     = var.pods_cidr
      services_cidr = var.services_cidr
    }
    persistent_volume_config {
      defined_tags = var.pv_defined_tags
    }
    service_lb_config {
      defined_tags = var.lb_defined_tags
    }
    service_lb_subnet_ids = [var.subnet_id_lb]
  }
}


resource "oci_containerengine_node_pool" "workers" {
  for_each       = var.pools != null ? var.pools : {}
  cluster_id     = oci_containerengine_cluster.containerengine_cluster.id
  compartment_id = var.compartment_ocid
  initial_node_labels {
    key   = "name"
    value = format("%s%s", "oke-", var.name)
  }
  kubernetes_version = var.k8s_version
  name               = each.key
  node_config_details {
    dynamic "placement_configs" {
      for_each = data.oci_identity_availability_domains.ads.availability_domains
      content {
        availability_domain = placement_configs.value.name
        subnet_id           = var.subnet_id_node
      }
    }
    size         = each.value.pool_total_vm
    defined_tags = each.value.vm_defined_tags
  }
  node_shape = each.value.vm_shape
  node_shape_config {
    memory_in_gbs = each.value.vm_memory
    ocpus         = each.value.vm_ocpu
  }
  node_source_details {
    image_id    = data.oci_core_images.oke_images[each.key].images[0].id
    source_type = "IMAGE"
  }
}