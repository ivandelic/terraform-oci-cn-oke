variable "compartment_ocid" {
  description = "OCID of a compartment where OKE is going to be placed."
  type = string
}
variable "name" {
  description = "Name of the OKE instance. The name will be reused to create node pool also."
  type = string
}
variable "k8s_version" {
  description = "The version of Kubernetes to install into OKE cluster in format 'v1.24.1'. Please check supported versions here: https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengaboutk8sversions.htm#supportedk8sversions"
  type = string
}
variable "is_api_endpoint_public" {
  description = "Flag to indicate ig Kubernetes API Endpoint will have public IP address. Default is false. If it's set to true, subnet subnet_id_node needs to be public."
  default = false
  type = bool
}
variable "cni_type" {
  description = "Type of CNI plugin. Module supports 'FLANNEL_OVERLAY' or 'OCI_VCN_IP_NATIVE'"
  default = "FLANNEL_OVERLAY"
  type = string
}
variable "oke_defined_tags" {
  description = "Defined tags for the OKE cluster."
  default = {}
  type = map
}
variable "lb_defined_tags" {
  description = "Defined tags for the load balancers created by the OKE."
  default = {}
  type = map
}
variable "pv_defined_tags" {
  description = "Defined tags for the persistent volumes created by the OKE."
  default = {}
  type = map
}
variable "is_dashboard_enabled" {
  description = "FLag to indicate if Kubernetes dashboard will be installed. Since it poses as significant attacking vector, it's disabled by default."
  default = false
  type = bool
}
variable "is_image_verification_enabled" {
  description = "Flag to indicate if the image verification policy is enabled. Default is false. If set to true, you need to assign verification key OCID."
  default = false
  type = bool
}
variable "image_verification_key_id" {
  description = "OCID of Vault Key that will be used to verify whether the images are signed by an approved source."
  default = ""
  type = string
}
variable "pods_cidr" {
  description = "CIDR block for Kubernetes pods. Default is 10.244.0.0/16."
  default = "10.244.0.0/16"
  type = string
}
variable "services_cidr" {
  description = "CIDR block for Kubernetes services. Default is 10.96.0.0/16."
  default = "10.96.0.0/16"
  type = string
}
variable "vcn_id" {
  description = "OCID of a VCN on which OKE will be placed."
  type = string
}
variable "subnet_id_lb" {
  description = "Targeted subnet for load balancers."
  type = string
}
variable "subnet_id_node" {
  description = "Targeted subnet for worker nodes."
  type = string
}
variable "subnet_id_endpoint" {
  description = "Targeted subnet for K8s API endpoint."
  type = string
}
variable "pools" {
  description = "Map of node pools."
  type = map(object({
    pool_total_vm = optional(number, 3)
    vm_shape = optional(string, "VM.Standard.E4.Flex")
    vm_memory = optional(number, 8)
    vm_ocpu = optional(number, 2)
    vm_image_name = string
    vm_defined_tags = optional(map(string))
  }))
}