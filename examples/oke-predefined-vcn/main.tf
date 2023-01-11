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

module "oke" {
  source           = "ivandelic/cn-oke/oci"
  compartment_ocid = var.compartment_ocid
  k8s_version      = "v1.24.1"
  name             = "test"
  pools             = {
    pool-1 = {
      vm_image_name = "Oracle-Linux-7.9-2022.10.04-0"
    }
  }
  subnet_id_endpoint = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaazlagqecsstgg6e2j6gnk3h62ph32egex56rzxafdbjycwiiv67yq"
  subnet_id_lb = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaav4spwvps4jmy4ijpizbhbrs7kfqhkio6ybmvll4iedzlcepn6jna"
  subnet_id_node = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaadzbbhwczbsetqiiodadafduednrt75yduysmtgnvuxb5bjtdan6a"
  vcn_id = "ocid1.vcn.oc1.eu-frankfurt-1.amaaaaaauevftmqamgt2k643vyyvxgnahzqt3i2ac4pspk6knuygz5lvu66q"
}
