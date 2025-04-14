DRY: If we look at `filename` in line 6, and line 11 of our two resource blocks, the expression `path.module` is used each time we want to specify the location of the files to be created by `terraform`. This means we repeated ourselves multiple times. This is not the best pracice in coding. 


## BEFORE LOCAL VARIABLE
```bash
resource "local_file" "example" {
  count    = 2
  filename = "${path.module}/example_${count.index}.txt"
  content  = "It's good to know terraform local providers.\nI'll 4eva be grateful.\nThanks!!!"
}

resource "local_sensitive_file" "sensitive" {
  filename = "${path.module}/sensitive.txt"
  content  = "This is my new password.\nIt should stay sensitive.\nThis is best practice."
}

```
To solve this `DRY` problem, we've' to use a local variable.

What is a `local variable` ?

A `local variable` is an input variable which assigns a name to an expression, so we can use the name multiple times within a module instead of repeating the expression.

*Define a local variable*

```bash
locals {
  base_path = "${path.module}/files"
}
```
In the `local block` above, the expression `${path.module}` means a path to the pwd or cwd. And `${path.module}/files` means that a directory called `files` should be created within the pwd.


*How to use a local variable multiple times in a config file*

## AFTER LOCAL VARIABLE

```bash
locals {
  base_path = "${path.module}/files"
}

resource "local_file" "example" {
  count    = 2
  filename = "${local.base_path}/example_${count.index}.txt"
  content  = "It's good to know terraform local providers.\nI'll 4eva be grateful.\nThanks!!!"
}

resource "local_sensitive_file" "sensitive" {
  filename = "${local.base_path}/sensitive.txt"
  content  = "This is my new password.\nIt should stay sensitive.\nThis is best practice."
}
```
It is seen that we are confortably using the local variable in multiple block as it was before. Instead of using the expression `${path.module}` multiple times, we used `${local.path}` multiple times within our config file. 

The `example_1.txt`, `example_2.txt`, and `sensitive.txt` files shall be created within the `files` directory.

## Use Locals to create different Workspaces (dev, staging, and prod) in Your Project Directory


```bash
locals {
  environment = "dev" # dev, staging, prod
  upper_case  = upper(local.environment)  # We Change the workpsace name to uppercase
  base_path   = "${path.module}/config/${local.upper_case}" # put the desired workspace in 'config' directory. 
}

resource "local_file" "server" {

  filename = "${local.base_path}/server.sh"
  content  = <<EOT
  environment =${local.environment}
  port=8080
  EOT
}

resource "local_sensitive_file" "sensitive" {
  filename = "${local.base_path}/password.txt"
  content  = "localvariables123!"
}
```

In this case, when we run `terraform apply`, a `config` directory will be created in our cwd, `${path.module}` and a `DEV` directory will be nested within the `config` directory. That is `config\DEV`. Within the `DEV` directory will be created two files, `password.txt`, and `server.sh`. 

If we use the `dev` environment, the content of `password.txt`, and `server.sh` will appear in our cwd under `config\DEV` directory as follows:

`password.txt = localvariables123!` and `server.sh` will be

```bash
# server.sh
  environment=dev
  port=8080
```
If we use the `staging` environment, the content of `password.txt`, and `server.sh` will appear in our cwd under `config\[DEV, STAGING]` directory as follows:

`password.txt = localvariables123!` and `server.sh` will be
```bash
# server.sh
  environment=staging
  port=8080
```

If we use the `prod` environment, the content of `password.txt`, and `server.sh` will appear in our cwd under `config\[DEV, STAGING, PROD]` directory as follows:

`password.txt = localvariables123!` and `server.sh` will be

```bash
# server.sh
  environment=prod
  port=8080
```
