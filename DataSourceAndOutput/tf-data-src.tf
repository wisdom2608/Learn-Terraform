###############################################################################
#                                TERRAFORM DATA SOURCE
################################################################################

resource "aws_instance" "wisdom" {
  ami           = "ami-0862be96e41dcbf74"
  instance_type = "t2.micro"
  key_name      = "VM-KP"
  # subnet_id = xxxx.id
  availability_zone      = "us-east-2a"
  vpc_security_group_ids = ["default"]
  tags = {
    Name = "TF EC2"
  }
}
# Why Terraform Data Source?
#       Assume that you are aws developer and you are working on a terraform script.
#       Above is your terraform script where you want to launch an ec2 instance on aws cloud.
#       On the resource block of the instance are arguments of the instance including t2.micro.
#       The tag which is a name is "TF EC2" terraform. 
#       So, when we apply this terraform script, it's going to create this EC2 instance on the aws environment. 
#       
#       What if you want to know the attributes or details such as instance IP, ID, of this instance that has just been created ?
#       ...To get these attributes you can sign into the console and fetch them by clicking on the instance' "detail tap".
#       
#       What if you want to these attributes only using the tf script?
#       .... Remember the imput instruction only requires tf to create an EC2 instance.
#       .... It does not ask terraform to fetch us any output that we may need to know without necessarily using the management console.
#       
#       If you need to know any attribute of any of your resources created by tf on aws. You have to request for it...
#        ... and this is why tf data source comes in.
# 
###################################################################################################################
#                       SYNTAX OF DATA SOURCE AND HOW TO CREATE A DATA SOURCES IN A TERRAFORM FILE
###################################################################################################################

data "aws_instance" "my_instance" {
  filter {
    name   = "tag:Name"
    values = ["TF EC2"]
  }
  depends_on = [aws_instance.wisdom]
}

output "fetch_info_from_aws_instance" {
  value = [data.aws_instance.my_instance.public_ip, data.aws_instance.my_instance.id]
}

#      Above is the structure, or definition of a data sources.
#      There are two concepts:
#      - the data block.
#      - the output block.
#      
#      Data block refers to data sources and output block refers to the information to be gotten back from aws environment
# 
# -------------------------------------------------------------------------------------------------
#              Let's explain the data source or the data block of the script above
#--------------------------------------------------------------------------------------------------
#   
#      In the data, the resource we want to create is "aws_instance" (which is the Data Source Type) and we have give the name... 
#        .... "my_instance" (which is the Reference Name of the resource we want to create).
#
#      The second thing we've defined is the filter. So, we do we define the filter? 
#      - Lat's assume we are working in an aws environment where we need to create multiple ec2 instances. You want to create a data... 
#       .... source and you some information from aws but you have a multiple numbers of instances. So, which one do we choose? That's why ...
#       .... we filter some particular resources. In the data block above we are filtering informatiom from an instance which has a tag name ...
#       .... "TF-EC2". That is why we have to define the filter. 
#
#       Secondly, we need to define the dependency. so, why the dependency? We have create the resource block ok the EC2 instance. We need to ...
#       ... to find some information from the EC2 instance. So We have to define the dependency of that resource block. The attributes of the ...
#       ... of the instance we are targeting will only be made available after the instance has been created. The dependency value is the combination ...
#       ...  the Sesource Type Nmae and the Reference Type Name, separated with a dot. That is "aws_instance.wisdom".
#
#------------------------------------------------------------------------------------------------------------------
#                                   Output block
#------------------------------------------------------------------------------------------------------------------
#       For output block, the Reference Type Name can be anything of your choice. For instance "fetch info from aws_instance" is the name of mu choice...
#       ... It is not conventional. Also, the value of the outpent depends on the attribute you want to fetch from the resource. ...
#       ... for me, i want to fetch the instance's public ip address. That is i put "data.aws_instance.my_instance.public_ip". ..
#       ... You can fetech some attributes such as the instance id, private ip, etc.



