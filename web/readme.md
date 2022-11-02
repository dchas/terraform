1--> install the terraform and setup the path
2--> install the aws-cli and configure the keys
profile for the aws-cli : your usr home directory --> .aws/
config/credentials


argument : (input)
attributes : (output)


terraform.exe plan --var-file devops.tfvars
Q.what is tfstate ?
A--> store created resource information


1)..create the scenario for the forces replacement----can see kyeword----forces replacement



we are going to create vpc by using terraform
provider : aws
region : ap-south-1
resource : vpc
cidr : 10.1.0.0/16
enable dns host = true

creating subents by using terraform
publicsubnet : ["10.1.0.0/24","10.1.1.0/24,"10.1.2.0/24"]
privatesubnet : ["10.1.3.0/24","10.1.4.0/24,"10.1.5.0/24"]
datasubnet : ["10.1.6.0/24","10.1.7.0/24,"10.1.8.0/24"]

igw =
attach =
eip =
nat-gw =

route tables
pubroute =
private route =


associate the publicsubnets with the igw
associate the peivatesubnets with the nat-gw

terraform init
terraform validate 
terraform plan 
terraform apply




privatesubnets = ["10.1.3.0/24","10.1.4.0/24","10.1.5.0/24"]
datasubnets = ["10.1.6.0/24","10.1.7.0/24","10.1.8.0/24"]