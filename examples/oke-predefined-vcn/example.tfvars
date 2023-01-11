k8s_version = "v1.24.1"
oke_name    = "example"
vcn_name    = "example"
vcn_cidr    = "10.0.0.0/16"
vcn_subnets = {
  k8s-endpoint-api = {
    cidr_block = "10.0.0.0/30"
    is_public  = true
    rt_rules   = [
      {
        description         = "Traffic to Internet"
        destination         = "0.0.0.0/0"
        destination_type    = "CIDR_BLOCK"
        network_entity_type = "ig"
      }
    ]
    sl_rules = {
      ingress_security_rules = [
        {
          description = "Kubernetes worker to Kubernetes API endpoint communication"
          protocol    = "6"
          source      = "10.0.1.0/24"
          tcp_options = {
            min = 6443
            max = 6443
          }
        },
        {
          description = "Kubernetes worker to control plane communication"
          protocol    = "6"
          source      = "10.0.1.0/24"
          tcp_options = {
            min = 12250
            max = 12250
          }
        },
        {
          description  = "Path discovery"
          icmp_options = {
            code = "4"
            type = "3"
          }
          protocol = "1"
          source   = "10.0.1.0/24"
        },
        {
          description = "External access to Kubernetes API endpoint"
          protocol    = "6"
          source      = "0.0.0.0/0" #WARNING: Limit CIDR to more specific, or bastion CIDRs
          tcp_options = {
            min = 6443
            max = 6443
          }
        }
      ]
      egress_security_rules = [
        {
          description      = "Allow Kubernetes Control Plane to communicate with OKE"
          destination      = "all-fra-services-in-oracle-services-network"
          destination_type = "SERVICE_CIDR_BLOCK"
          protocol         = "6"
        },
        {
          description      = "Path Discovery"
          destination      = "all-fra-services-in-oracle-services-network"
          destination_type = "SERVICE_CIDR_BLOCK"
          icmp_options     = {
            code = "4"
            type = "3"
          }
          protocol = "1"
        },
        {
          description      = "Allow Kubernetes control plane to communicate with worker nodes."
          destination      = "10.0.1.0/24"
          destination_type = "CIDR_BLOCK"
          protocol         = "6"
        },
        {
          description      = "Path discovery"
          destination      = "10.0.1.0/24"
          destination_type = "CIDR_BLOCK"
          icmp_options     = {
            code = "4"
            type = "3"
          }
          protocol = "1"
        }
      ]
    }
  }
  worker-node = {
    cidr_block = "10.0.1.0/24"
    is_public  = false
    rt_rules   = [
      {
        description         = "Traffic to Internet"
        destination         = "0.0.0.0/0"
        destination_type    = "CIDR_BLOCK"
        network_entity_type = "ng"
      },
      {
        description         = "traffic to OCI services"
        destination         = "all-fra-services-in-oracle-services-network"
        destination_type    = "SERVICE_CIDR_BLOCK"
        network_entity_type = "sg"
      }
    ]
    sl_rules = {
      ingress_security_rules = [
        {
          description = "Allow pods on one worker node to communicate with pods on other worker nodes"
          protocol    = "all"
          source      = "10.0.1.0/24"
        },
        {
          description = "Allow Kubernetes control plane to communicate with worker nodes"
          protocol    = "6"
          source      = "10.0.0.0/30"
        },
        {
          description  = "Path discovery"
          icmp_options = {
            code = "4"
            type = "3"
          }
          protocol = "1"
          source   = "0.0.0.0/0"
        },
        {
          description = "Allow inbound SSH traffic to worker nodes."
          protocol    = "6"
          source      = "10.0.3.0/24" # WARNING: Select the most appropriate CIDRs for SSH access
          tcp_options = {
            min = 22
            max = 22
          }
        },
        {
          description = "Load Balancer to Worker nodes node ports"
          protocol    = "6"
          source      = "10.0.2.0/24"
          tcp_options = {
            min = 30000
            max = 32767
          }
        }
      ]
      egress_security_rules = [
        {
          description      = "Allow pods on one worker node to communicate with pods on other worker nodes"
          destination      = "10.0.1.0/24"
          destination_type = "CIDR_BLOCK"
          protocol         = "all"
        },
        {
          description      = "Path Discovery"
          destination      = "0.0.0.0/0"
          destination_type = "CIDR_BLOCK"
          icmp_options     = {
            code = "4"
            type = "3"
          }
          protocol = "1"
        },
        {
          description      = "Allow nodes to communicate with OKE"
          destination      = "all-fra-services-in-oracle-services-network"
          destination_type = "SERVICE_CIDR_BLOCK"
          protocol         = "6"
        },
        {
          description      = "Kubernetes worker to Kubernetes API endpoint communication"
          destination      = "10.0.0.0/30"
          destination_type = "CIDR_BLOCK"
          protocol         = "6"
          tcp_options      = {
            min = 6443
            max = 6443
          }
        },
        {
          description      = "Kubernetes worker to control plane communication"
          destination      = "10.0.0.0/30"
          destination_type = "CIDR_BLOCK"
          protocol         = "6"
          tcp_options      = {
            min = 12250
            max = 12250
          }
        },
        {
          description      = "Worker Nodes access to Internet"
          destination      = "0.0.0.0/0" # WARNING: Optional, for reaching internet from workers by NAT
          destination_type = "CIDR_BLOCK"
          protocol         = "6"
        }
      ]
    }
  }
  load-balancer = {
    cidr_block = "10.0.2.0/24"
    is_public  = true
    rt_rules   = [
      {
        description         = "Traffic from Internet"
        destination         = "0.0.0.0/0"
        destination_type    = "CIDR_BLOCK"
        network_entity_type = "ig"
      }
    ]
    sl_rules = {
      ingress_security_rules = [
        {
          description = "Allow Load Balancer listener protocol and port"
          protocol    = "6"
          source      = "0.0.0.0/0"
          source_type = "CIDR_BLOCK"
          tcp_options = {
            max = 443
            min = 443
          }
        }
      ]
      egress_security_rules = [
        {
          description = "Allow Load Balancer to Worker nodes node ports"
          destination = "10.0.1.0/24"
          protocol    = "6"
          tcp_options = {
            min = 30000
            max = 32767
          }
        }
      ]
    }
  }
  bastion = {
    cidr_block = "10.0.3.0/24"
    is_public  = false
    sl_rules   = {
      egress_security_rules = [
        {
          description = "Allow bastion to access the Kubernetes API endpoint"
          destination = "10.0.0.0/30"
          protocol    = "6"
          tcp_options = {
            min = 6443
            max = 6443
          }
        },
        {
          description = "Allow SSH traffic to worker nodes."
          destination = "10.0.1.0/24"
          protocol    = "6"
          tcp_options = {
            min = 22
            max = 22
          }
        }
      ]
    }
  }
}