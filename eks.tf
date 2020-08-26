module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "12.2.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_enabled_log_types       = var.cluster_enabled_log_types
  cluster_log_retention_in_days   = var.cluster_log_retention_in_days
  cluster_log_kms_key_id          = var.cluster_log_kms_key_id
  cluster_endpoint_private_access = var.cluster_endpoint_access == "private" || var.cluster_endpoint_access == "both" ? true : false
  cluster_endpoint_public_access  = var.cluster_endpoint_access == "public" || var.cluster_endpoint_access == "both" ? true : false
  cluster_delete_timeout          = var.cluster_delete_timeout

  write_kubeconfig   = true
  config_output_path = "${path.module}/"
  # Use aws cli for authentication
  kubeconfig_aws_authenticator_command = "aws"
  kubeconfig_aws_authenticator_command_args = [
    "--region",
    data.aws_region.current.name,
    "eks",
    "get-token",
    "--cluster-name",
    var.cluster_name,
  ]

  enable_irsa = var.enable_irsa

  vpc_id  = var.vpc_id
  subnets = var.subnets

  tags = merge(
    {
      Name = var.cluster_name
    },
    var.tags
  )

  node_groups = var.node_groups

  map_roles = var.map_roles
}