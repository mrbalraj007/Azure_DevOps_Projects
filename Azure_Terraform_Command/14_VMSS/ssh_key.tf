resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/day_key"
}

resource "local_file" "public_key" {
  content  = tls_private_key.example.public_key_openssh
  filename = "${path.module}/day_key.pub"
}