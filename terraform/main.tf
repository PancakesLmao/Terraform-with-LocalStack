# terraform/main.tf

resource "aws_s3_bucket" "frontend" {
  bucket = "pankeki-frontend"
}

resource "aws_s3_object" "frontend_files" {
  for_each = fileset("${path.module}/../Pankeki-Express/frontend/dist", "**/*")

  bucket = aws_s3_bucket.frontend.bucket
  key    = each.value
  source = "${path.module}/../Pankeki-Express/frontend/dist/${each.value}"

  acl = "public-read"   # ? ADD THIS

  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "svg"  = "image/svg+xml",
  }, reverse(split(".", each.value))[0], "binary/octet-stream")
}

resource "aws_instance" "demo" {
  ami           = "ami-12345678"   # fine for LocalStack
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