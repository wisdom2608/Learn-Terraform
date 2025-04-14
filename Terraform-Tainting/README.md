## Terraform Tainting and Replace

# 1. Terraform Tainting
Imagine you create an EC2 instance and realize sooner or later, that it is not working properly. What you can do is to replace the instance. To do this, you have to mark it (the instance) as a taint. Whatever resource you mark as a taint is tainted in the state file. Next time when you run `terraform plan` or `terraform apply` command, it will replace the existing damaged instance which you have tainted, with a new one.

. The `terraform taint` command informs Terraform that a particular resource has become degrated or damaged.
. Terraform represents this by marking the resource/object as "tainted" in the terraform state, and Terraform will propose to replace it in the next `plan` that you create.
. This command is deprecated for terraform v0.15.2 and later, we recommend using the `-replace` option  with `terraform apply`.

```bash
terraform taint < resource_name.local_name >

```
The `resource_name` is normaly the name of the resource. For instance `aws_instance`, and the `local_name` is the name you give as per your need. The resource_name and the local_name can also be called the `the resource address`

# Example: 
Let's deploy an EC2 instance in aws 

```bash
resource "aws_instance" "test" {
    ami = var.ami
    key_name = "Test-Key"
    instance_type = "t2.micro"
    tags = {
      Name = "Test-instance"
    }
}
```
If we realise that this instance is not functioning well, we can taint it. To taint it successfully, we've to know the address of the instance.

*How to find the address of the resource you want to taint*

*Let's say you want to find the address of the EC2 instance above, you run the following command* 

```bash
terraform state list
```
Output: `aws_instance.test`

*How to taint a damaged instance.*

```bash
terraform taint aws_instance.test
```
Output: `Resource Instance aws_instance.test has been marked as tainted.`

When you run the `terraform plan` and `terraform apply` command, terraform will destroy the damaged instance and create a new one. 

# 2. Replace and keep the old resource

Tainting a resource is just one way. Another way is that if you find out that a resource is damaged and you wish to keep it, create a new one, and then find out what happened (troubleshoot it), you can remove the damaged resource from the state file. 

For the case of our EC2 instance, you may think the instance has an issue and you need to keep it running until you have time to troubleshoot what is wrong with it by checking the logs.

You can remove the damaged EC2 instance from the terraform state file. When a resource is removed from tf state file, it means Terraform will "forget" that the EC2 instance exists. The next time you execute the planning phase, it will create a new one and the old one will keep running. The old one keeps rinning because it's been removed from terraform state file which does not recognise it or manage that particular EC2 instance anymore.

*How to remove the instance from the state file*

```bash
terraform state rm aws_instance.test
```
Output: `Removed aws_instance.test`
         `Successfully removed 1 resource instance(s)`

*Create a new EC2 instance*

```bash
terraform apply -auto-approve
```

# 3. Terraform Force Replacement

Using the `-replace` flag with `terraform plan` or `terraform apply`, to force Terraform to replace a resource even though there are no modification that would require it.

```bash
terraform plan -replace="aws_instance.test"
```

```bash
terraform apply -replace="aws_instance.test"
```

# 4. Terraform Untaint

Suppose Terraform has set a resource as tainted, but you feel it is working perfectly and does not need to be replaced. We can override the tainted resource in the terraform state file (or we can override the terraform decision to replace the resource) by utilizing `terraform untaint` command.

*untaint the resource marked tainted in the terraform state file*

```bash
terraform untaint aws_instance.test
```
