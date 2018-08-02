resource "aws_key_pair" "keypair-wh" {
  key_name   = "${format("%s-%s", "wh", var.env)}"
  public_key = "${file("${path.module}/wh_id_rsa.pub")}"
}
