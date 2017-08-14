module "foo" {
  source = "module"
  tag_name = "goodbye world"
  cluster_name = "foo"
  region = "us-east-1"
}

module "boo" {
  source = "module"
  tag_name = "hello world"
  cluster_name = "boo"
  region = "us-east-2"
}

