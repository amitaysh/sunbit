# Sunbit.
Example for using Terraform (newly learned technology).

## This repository will implement this request:
```
First, make sure you have access to a MySQL server with root username & password. (Local on your machine or remote)
Write a Terraform configuration that will use Terraform MySQL provider.
This configuration will take as a variable a list of databases names, a map of usernames and passwords. Both list and map can have any number of items.
The configuration should create the following:
    1. Create MySQL databases for each item in the databases list.
    2. Create users for each item in the users map with the correct password.
    3. Grant "SELECT" permission for each user to each database from the list.
In order to verify it, run your configuration with 3 databases and 4 users.
This configuration should be efficient and support any number of databases and users.
```

## The implementation
MySql -> Terraform -> .tf file

### MySql
First I've installed MySql on a docker with ubuntu:
```
apt-get install mysql-server
```

### Terraform
Terraform doesn't require installation, so I just downloaded the sources and used the binary file.

[Terraform](https://www.terraform.io/downloads.html) - Terraform download page

### Writing .tf file
During the implementation I've used several good documentation pages such as

[Terraform Documentation](https://learn.hashicorp.com/terraform/getting-started/build) - Official documentation for building infrastructure

[MySql Provider](https://www.terraform.io/docs/providers/mysql/index.html) - Official documentation for MySql Provider

[Terraform Lists and Maps](https://learn.hashicorp.com/terraform/getting-started/variables) - Official documentation for lists and maps usage

## Troubleshooting
I had several problems, and their fixes:
* Got some hard times getting terraform to work since MySql didn't had any root privileges in the container. [This](https://stackoverflow.com/questions/39281594/error-1698-28000-access-denied-for-user-rootlocalhost) gave me a good hint. (MySql uses system root account and NOT db root account...)
* I needed a refresh on users management, [here](https://www.shellhacks.com/mysql-show-users-privileges-passwords/)
* The 'apply' part failed due to Terraform trying to grant user's permissions BEFORE creating them... [This](https://learn.hashicorp.com/terraform/getting-started/dependencies.html) helped a lot! ([Terraform claims](https://www.terraform.io/docs/configuration/load.html) that their process knows how to solve the dependencies, but a fact is that it failed until I've added "depends_on" section in the configuration file...)
* Grant "SELECT" over ALL databases, instead of just the ones supplied in the current run... [This](https://i-py.com/2017/Terraform-Usergen/) gave me a huge hint

## Documentation and screenshot
I've tried to document the steps within the configuration file (sunbit.tf), and here is an example command line for the 'apply' part of Terraform:
```
terraform apply -var 'db_names=["first_db","second_db","third_db"]' -var 'user_pass_map={"first_user"="pass", "second_user"="anotherpass", "third_user"="passpass", "forth_user"="morepass"}'
```
In addition - here are screenshots for example of usage:

![New Empty DB](/screenshots/empty_db.JPG)

![Terraform init](/screenshots/terraform_init.JPG)

![Terraform apply](/screenshots/terraform_apply.JPG)

![Full results DB](/screenshots/updated_grant.PNG)

## Summary
It was a great experience and Terraform is a great tool.
I had fun :)

Amitay.
