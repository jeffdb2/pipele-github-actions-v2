resource "aws_key_pair" "key" {
  key_name   = "aws-key-pipelines"
  public_key = var.aws_key_pub
}

resource "aws_instance" "vm" {
  ami                    = "ami-04f167a56786e4b09"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key.key_name
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnet_id
  vpc_security_group_ids = [ data.terraform_remote_state.vpc.outputs.security_group_id ]

  tags = {
    Name = "vm-terraform"
  }
}