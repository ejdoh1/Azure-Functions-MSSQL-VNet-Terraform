
resource "random_uuid" "main" {
}
locals {
  uuid = substr(replace(random_uuid.main.result, "-", ""), 0, 24)
}
