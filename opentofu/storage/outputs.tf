output "s3_bucket_incoming" {
  value = google_storage_bucket.incoming_bucket.name
}

output "s3_bucket_public" {
  value = google_storage_bucket.public_bucket.name
}

output "s3_access_key" {
  value = split("/", google_storage_hmac_key.hmac_key.id)[3] 
  sensitive = true
}

output "s3_secret_key" {
  value = google_storage_hmac_key.hmac_key.secret
  sensitive = true
}
