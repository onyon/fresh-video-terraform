resource "aws_ecr_repository" "imdb-sync" {
  name                  = "${var.product}/${local.workspace}/imdb-sync"
  image_tag_mutability  = "MUTABLE"
  force_delete          = true

  image_scanning_configuration {
    scan_on_push = true
  }
}