resource "google_pubsub_topic" "topic" {
  name = "hedwig-${var.topic}"
}

locals {
  iam_service_accounts = formatlist("serviceAccount:%s", flatten(var.iam_service_accounts))
}

data "google_iam_policy" "topic_policy" {
  binding {
    members = local.iam_service_accounts
    role    = "roles/pubsub.publisher"
  }

  binding {
    members = local.iam_service_accounts
    role    = "roles/pubsub.viewer"
  }
}

resource "google_pubsub_topic_iam_policy" "topic_policy" {
  count = length(var.iam_service_accounts) == 0 ? 0 : 1

  policy_data = data.google_iam_policy.topic_policy.policy_data
  topic       = google_pubsub_topic.topic.name
}

data "google_client_config" "current" {
}

resource "google_dataflow_job" "firehose" {
  count = var.enable_firehose_all_messages ? 1 : 0

  name              = "${google_pubsub_topic.topic.name}-firehose"
  temp_gcs_location = var.dataflow_tmp_gcs_location
  template_gcs_path = var.dataflow_template_gcs_path

  lifecycle {
    # Google templates add their own labels so ignore changes
    ignore_changes = [labels]
  }

  zone   = var.dataflow_zone
  region = var.dataflow_region

  parameters = {
    inputTopic           = "projects/${data.google_client_config.current.project}/topics/${google_pubsub_topic.topic.name}"
    outputDirectory      = var.dataflow_output_directory
    outputFilenamePrefix = var.dataflow_output_filename_prefix == "" ? format("%s-", google_pubsub_topic.topic.name) : var.dataflow_output_filename_prefix
  }
}
