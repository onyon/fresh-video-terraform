
# data "atlas_schema" "schema" {
#   src = file("${path.module}/database.hcl")
#   dev_db_url = "mysql://${aws_db_instance.self.username}:${random_password.rds_password.result}@${aws_db_instance.self.endpoint}/test"
# }

# resource "atlas_schema" "self" {
#   hcl = data.atlas_schema.schema.hcl
#   url = "mysql://${aws_db_instance.self.username}:${random_password.rds_password.result}@${aws_db_instance.self.endpoint}/${aws_db_instance.self.name}"
#   dev_db_url = "mysql://${aws_db_instance.self.username}:${random_password.rds_password.result}@${aws_db_instance.self.endpoint}/test"
# }