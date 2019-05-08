resource "google_pubsub_topic" "topic" {
  name = "hedwig-${var.topic}"
}
