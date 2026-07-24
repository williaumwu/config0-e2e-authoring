# Gateway Endpoints
resource "aws_vpc_endpoint" "s3" {
  depends_on      = [aws_vpc.main]
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${var.aws_default_region}.s3"
  route_table_ids = [aws_route_table.private.id, aws_default_route_table.public.id]

  tags = merge(
    var.cloud_tags,
    {
      Product = "vpc_endpoint"
      Name    = "s3-gw-endpt-${var.vpc_name}"
    },
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  depends_on      = [aws_vpc.main]
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${var.aws_default_region}.dynamodb"
  route_table_ids = [aws_route_table.private.id, aws_default_route_table.public.id]

  tags = merge(
    var.cloud_tags,
    {
      Product = "vpc_endpoint"
      Name    = "dynamodb-gw-endpt-${var.vpc_name}"
    },
  )
}

