resource "aws_sqs_queue" "new-media" {
  name                      = "${var.product}-${local.workspace}-new-media"
  max_message_size          = 262144
  receive_wait_time_seconds = 20
}