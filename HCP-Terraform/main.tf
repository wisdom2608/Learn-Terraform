resource "null_resource" "tfc_test" {
  provisioner "local-exec" {
    command = "echo 'Test Config' "
  }
}