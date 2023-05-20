ui = true

disable_mlock = true

storage "file" {
  path = "/opt/vault/data"
}

# HTTP listener
listener "tcp" {
  tls_disable     = 1
  address         = "[::]:8200"
  cluster_address = "[::]:8201"
}

seal "transit" {
  address         = "http://<ip adress of the host where the first vault server is running>:8200"
  disable_renewal = "false"
  key_name        = "autounseal"
  mount_path      = "transit/"
  tls_skip_verify = "true"
}
