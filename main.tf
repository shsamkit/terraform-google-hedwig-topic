resource "google_pubsub_topic" "topic" {
  name = "hedwig-${var.topic}"
}

data "google_client_config" "current" {}

resource "google_dataflow_job" "firehose" {
  count = "${var.enable_firehose_all_messages ? 1 : 0}"

  name              = "${google_pubsub_topic.topic.name}-firehose"
  temp_gcs_location = "${var.dataflow_tmp_gcs_location}"
  template_gcs_path = "${var.dataflow_template_gcs_path}"

  lifecycle {
    # Google templates add their own labels so ignore changes
    ignore_changes = ["labels"]
  }

  zone   = "${var.dataflow_zone}"
  region = "${var.dataflow_region}"

  parameters = {
    inputTopic           = "projects/${data.google_client_config.current.project}/topics/${google_pubsub_topic.topic.name}"
    outputDirectory      = "${var.dataflow_output_directory}"
    outputFilenamePrefix = "${var.dataflow_output_filename_prefix == "" ? format("%s-", google_pubsub_topic.topic.name) : var.dataflow_output_filename_prefix}"
  }
}
