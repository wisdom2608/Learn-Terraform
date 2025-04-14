# TERRAFORM WORKSPACES
When you have different tfvars file(e.g `dev.tfvars`, `staging.tfvars`, and `prod.tfvars`) and decide to pass one of the tfvars files to your CLI

If you want to create resources in the dev environment, the cmd is 

```bash
terraform init —var-file=dev.tfbackend # To initialize the environment with its backend
```

```bash
terraform apply —var-file=dev.tfvars
```

If you want to create resources in the staging environment, the cmd is 

```bash
terraform init —var-file=stage.tfbackend 
```

```bash
terraform apply —var-file=stage.tfvars
```

If you want to create resources in prod environment, the cmd is 

```bash
terraform init —var-file=prod.tfbackend
```

```bash
terraform apply —var-file=prod.tfvars
```

But this isn’t a good practice because the resources will not be created separately because the these different tfvars files sit in a module having a single tf.state file. What happens is that the resources created from `dev.tfvar` file shall instead be modified if we pass `stage.tfvars`, etc.

The best thing to do is to create tf workspace.

```bash
$ tree 
.
|-- README.md
|-- dev.tfvars
|-- main.tf
|-- modules
|   |-- EC2
|       |-- main.tf
|        `-- variables.tf
|-- providers.tf
|-- stage.tfvars
|-- terraform.tfstate
|-- terraform.tfstate.backup
|-- terraform.tfvars
|-- variables.tf

```

Accoding to the script above, when we run a `tree` cmd, it is seen that the `terraform.state` file is in the root 
directory including the `dev.tfvars`, `stage.tfvars`, and `prod.tfvars` files. This makes it impossible for different resources to create separately. They will instead be changed or modified because of the single `terraform.state` in the this root directory. 

To solve this problem or configure our code to create resource in different environment as we desire, we have to delete both `terraform.state`, `stage.tvars`, and `dev.tfvar` and then create directories for our dev, staging and prod enviroment where each of the environments will have its own state.file. This solves the problem of creating resources in the required environment without changing or modifying resources in the other environment.

```bash
$ tree
.
|-- README.md
|-- main.tf
|-- modules
|   |-- EC2
|       |-- main.tf
|       `-- variables.tf
|-- providers.tf
|-- terraform.tfvars
`-- variables.tf
```
Now we can create different terraform workspace in our root directory.

- *create worrkspace for dev environment* run the cmd

```bash
terraform workspace new dev
```
If we run a `tree` cmd we'll notice that within the root directory, a file has been created named `terraform.state.d`, there is a workspace called `dev`

```bash
$ tree
.
|-- README.md
|-- main.tf
|-- modules
|   `-- EC2
|       |-- main.tf
|       `-- variables.tf
|-- providers.tf
|-- terraform-workspaces
|-- terraform.tfstate.d
|   `-- dev
|-- terraform.tfvars
`-- variables.tf

```

- *create worrkspace for staging environment* run the cmd

```bash
terraform workspace new stage
```

If we re-run the`tree` cmd we'll notice that within  `terraform.state.d`, there is the`stage` workspace has been added.

```bash
$ tree
.
|-- README.md
|-- main.tf
|-- modules
|   `-- EC2
|       |-- main.tf
|       `-- variables.tf
|-- providers.tf
|-- terraform-workspaces
|-- terraform.tfstate.d
|   |-- dev
|   `-- stage
|-- terraform.tfvars
`-- variables.tf
```

- *create worrkspace for prod environment*run the cmd

```bash
terraform workspace new prod
```

If we re-run the`tree` cmd once more, we'll see that within  `terraform.state.d`, the`prod` workspace has been added.

```bash
$ tree
.
|-- README.md
|-- main.tf
|-- modules
|   `-- EC2
|       |-- main.tf
|       `-- variables.tf
|-- providers.tf
|-- terraform-workspaces
|-- terraform.tfstate.d
|   |-- dev
|   |-- prod
|   `-- stage
|-- terraform.tfvars
`-- variables.tf
```

How to switch to a workspace within terraform root directory. Run the cmd

```bash
terraform workspace select < workspace_name >
```
Now, let's consider that we want to switch to the `dev` workspace/dev environment

```bash
terraform workspace select dev
```
Output `Switched to workspace "dev".`

With the dev environment, we can execute the `terraform.tfvars` file. To do this, we run the cmd

```bash
terraform init
```

```bash
terraform apply

```
Here we will see resources being created but along with `dev` tf.state files. 
The tf.state file will be created within the `terraform.state.d`directory but not in the root of our project.

We see from the tree that after running creating resources in the `dev` environment, a tf.state file has been created for the `dev` workspace within the `terraform.state.d`directory

```bash
$ tree
.
|-- README.md
|-- main.tf
|-- modules
|   `-- EC2
|       |-- main.tf
|       `-- variables.tf
|-- providers.tf
|-- terraform-workspaces
|-- terraform.tfstate.d
|   |-- dev
|   |   `-- terraform.tfstate
|   |-- prod
|   `-- stage
|-- terraform.tfvars
`-- variables.tf

```

Let's consider that we want to switch to the `stage` workspace/dev environment

```bash
terraform workspace select stage

```

Output `Switched to workspace "stage".`

Here we will see resources being created but along with `stage` tf.state files. 
The tf.state file will be created within the `terraform.state.d`directory but not in the root of our project.

We see from the tree that after running creating resources in the `stage` environment, a tf.state file has been created for the `stage` workspace within the `terraform.state.d`directory

```bash
$ tree
.
|-- README.md
|-- main.tf
|-- modules
|   `-- EC2
|       |-- main.tf
|       `-- variables.tf
|-- providers.tf
|-- terraform-workspaces
|-- terraform.tfstate.d
|   |-- dev
|   |   |-- terraform.tfstate
|   |   `-- terraform.tfstate.backup
|   |-- prod
|   `-- stage
|       `-- terraform.tfstate
|-- terraform.tfvars
`-- variables.tf
```

Let's switch to the `prod` workspace/dev environment

```bash
terraform workspace select prod
```

Output `Switched to workspace "prod".`

Here we will see resources being created but along with `prod` tf.state files. 
The tf.state file will be created within the `terraform.state.d`directory but not in the root of the project.

We can see from the tree that after running creating resources in the `prod` environment, a tf.state file has been created for the `prod` workspace within the `terraform.state.d`directory

```bash
$ tree
.
|-- README.md
|-- main.tf
|-- modules
|   `-- EC2
|       |-- main.tf
|       `-- variables.tf
|-- providers.tf
|-- terraform-workspaces
|-- terraform.tfstate.d
|   |-- dev
|   |   |-- terraform.tfstate
|   |   `-- terraform.tfstate.backup
|   |-- prod
|   |   `-- terraform.tfstate
|   `-- stage
|       |-- terraform.tfstate
|       `-- terraform.tfstate.backup
|-- terraform.tfvars
`-- variables.tf
```

The `terraform.backup.state` files appeared in the trees because you actually deleted the resources that we created.

CONCLUCSION: To make things simple, we can create `tfvars` of each environment in the root directory and then pass it on `terraform apply`.

For example if we want to create resources in the `dev` environment, we can run

```bash
terraform apply —var-file=dev.tfvars
```

if we wan to create resources in the `staging` environment, we can run

```bash
terraform apply —var-file=stage.tfvars
```
if we wan to create resources in the `prod` environment, we can run

```bash
terraform apply —var-file=prod.tfvars
```