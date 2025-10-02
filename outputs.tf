output "containerengine_cluster" {
  value = oci_containerengine_cluster.containerengine_cluster
}

output "containerengine_nodepool" {
  value = oci_containerengine_node_pool.workers
}