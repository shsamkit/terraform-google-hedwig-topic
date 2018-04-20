resource "aws_sns_topic" "topic" {
  name = "hedwig-${var.topic}"
}
