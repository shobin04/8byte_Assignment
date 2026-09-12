output "private_key_pem" {
  description = "Private key in PEM format"
  value       = tls_private_key.rsa.private_key_pem
  sensitive   = true
}