# Example 1: OKE with Flannel
The example will create a simple OKE instance with a single node pool.
It uses Terraform module [cn-oke](https://registry.terraform.io/modules/ivandelic/cn-oke/oci/latest) to provision OKE.

## Prerequisites
+ OCI CLI [installed and configured](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)
+ Terraform [installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-cli)

## Outcome
By executing the example Terraform code, a single OKE (```oke-example```) will be provisioned with single node pool (```pool-1```).

## Explanation
A concrete example that generates ```oke-example``` OKE is located in file [example.tfvars](example.tfvars).

## Run the Example

### 1. Initialize Terraform
Position terminal in ```examples/oke-predefined-vcn``` folder. Initialize Terraform with the following command:
```
terraform init
```

### 2. Execute Apply to Create OKE
Stay in the same folder and execute apply command:
```
terraform apply -var-file=example.tfvars
```
Action will create cloud-native OKE described in [Outcome](#outcome). Note that apply command passes parameters via the ```-var-file=example.tfvars``` flag. The flag references example file [example.tfvars](example.tfvars), where all the magic is defined.

### 3. Finalize
You are now ready to proceed and put some workloads on top of OKE.