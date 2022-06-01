resource "random_string" "alb_prefix" {
  length  = 4
  upper   = false
  special = false
}