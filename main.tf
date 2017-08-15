module "foo" {
  source = "module"
  tag_name = "goodbye world"
  cluster_name = "foo"
  region = "us-east-2"
  cidr_block = "10.1.0.0/16"
  subnet = "10.1.0.0/24"
}

module "boo" {
  source = "module"
  tag_name = "hello world"
  cluster_name = "boo"
  region = "us-east-2"
  cidr_block = "10.2.0.0/16"
  subnet = "10.2.0.0/24"
}
