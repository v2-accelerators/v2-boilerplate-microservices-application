terraform {
  source = "../../../additional_modules/helm"
}
include "root"{
	path = find_in_parent_folders()
}

locals {
    config_path = "${get_terragrunt_dir()}/../config.yml"
    config = yamldecode(file(local.config_path))
}


dependency "ebs" {
  config_path = "../ebs"
  mock_outputs = {
    oidc_provider = ""
  }
}
inputs = {
  // cluster_name = "${get_env("RESOURCE_PREFIX", "")}-${local.config.eks.cluster_name}"
  cluster_name = local.config.eks.cluster_name
  deployment_name = local.config.grafana.deployment_name
  repository_link = local.config.grafana.repository_link
  chart_name = local.config.grafana.chart_name
  values = ["${file("${find_in_parent_folders("${local.config.grafana.config_file}")}")}"]
}