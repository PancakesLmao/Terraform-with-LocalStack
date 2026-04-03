# terraform/main.tf

resource "aws_s3_bucket" "frontend" {
  bucket = "frontend"
}

resource "aws_s3_object" "frontend_files" {
  for_each = fileset("${path.module}/../Pankeki-Express/frontend/dist", "**/*")

  bucket       = aws_s3_bucket.frontend.bucket
  key          = each.value
  source       = "${path.module}/../Pankeki-Express/frontend/dist/${each.value}"
  acl          = "public-read"

  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "svg"  = "image/svg+xml",
  }, reverse(split(".", each.value))[0], "binary/octet-stream")
}

# Static website hosting
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

# Public read policy
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = ["s3:GetObject"]
      Resource  = ["${aws_s3_bucket.frontend.arn}/*"]
    }]
  })
}

# Bucket ACL
resource "aws_s3_bucket_acl" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  acl    = "public-read"
}

resource "aws_instance" "backend" {
  ami           = "ami-12345678"
  instance_type = var.instance_type
  key_name      = "my-key"

  user_data = templatefile("${path.module}/user_data.sh", {
    repo_url = "https://github.com/PancakesLmao/Pankeki-Express.git"
    branch   = "dev"
  })

  tags = {
    Name = "terraform-localstack-backend"
  }
}