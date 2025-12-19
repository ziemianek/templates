resource "aws_dynamodb_table" "products" {
  name         = "${var.name}-products-${var.env_type}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "product_id"

  attribute {
    name = "product_id"
    type = "S"
  }

  tags = {
    Name = "${var.name}-products-${var.env_type}"
  }
}
