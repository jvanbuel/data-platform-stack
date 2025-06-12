resource "upcloud_managed_object_storage_user" "this" {
  username     = "dp-terraform"
  service_uuid = upcloud_managed_object_storage.this.id
}

resource "upcloud_managed_object_storage_user_access_key" "this" {
  username     = upcloud_managed_object_storage_user.this.username
  service_uuid = upcloud_managed_object_storage.this.id
  status       = "Active"
}
