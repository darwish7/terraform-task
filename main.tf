module "main-vpc" {
  source         = "./vpc"
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "main-vpc"
}

module "pub_subnet" {
  source                   = "./pub_subnet"
  vpc-id                   = module.main-vpc.vpc-id
  subnet_cidr_block        = { us-east-2a = "10.0.0.0/24", us-east-2b = "10.0.2.0/24" }
  igw_name                 = "public_igw"
  cidr_block_public_source = "0.0.0.0/0"
}

module "private_subnet" {
  source                   = "./private_subnet"
  vpc-id                   = module.main-vpc.vpc-id
  subnet_cidr_block        = { us-east-2a = "10.0.1.0/24", us-east-2b = "10.0.3.0/24" }
  cidr_block_public_source = "0.0.0.0/0"
  natgw_subnet             = module.pub_subnet.subnet-id[0]
}


module "ALP" {
  source            = "./ALP"
  tg_name           = "public-target-group"
  vpc_id            = module.main-vpc.vpc-id
  tg_ec2_ids        = module.proxy-ec2.proxy-ips
  public_subnet_ids = module.pub_subnet.subnet-id
}

module "NLP" {
  source = "./NLP"
  tg_name           = "private-target-group"
  vpc_id            = module.main-vpc.vpc-id
  tg_ec2_ids        = module.private-ec2.private-ec2-ips
  private_subnet_ids = module.private_subnet.subnet-id
}

module "proxy-ec2" {
  source          = "./proxy_ec2"
  vpc_id          = module.main-vpc.vpc-id
  instance_type   = "t2.micro"
  public_ec2_name = "proxy_machine"
  subnet_ids      = module.pub_subnet.subnet-id
  inline-provisioner-remote-exec = ["sudo apt update -y",
      "sudo apt install -y nginx",
      "echo 'server { \n listen 80 default_server; \n  listen [::]:80 default_server; \n  server_name _; \n  location / { \n  proxy_pass http://${module.NLP.nlp_dns}; \n  } \n}' > default",
      "sudo mv default /etc/nginx/sites-enabled/default",
      "sudo systemctl stop nginx",
      "sudo systemctl start nginx",]

}

module "private-ec2" {
  source          = "./private_ec2"
  vpc_id          = module.main-vpc.vpc-id
  instance_type   = "t2.micro"
  private_ec2_name = "private_machine"
  subnet_ids      = module.private_subnet.subnet-id
}