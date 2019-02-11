# Configure the MySQL provider
provider "mysql" {
  endpoint = "localhost:3306"
  username = "root"
  password = "123456"
}

# db_names will hold names of DBs
variable "db_names" {type = "list"}

# usernames and passwords
variable "user_pass_map" {type = "map"}

# Create DB for each db provided
resource "mysql_database" "sunbit" 
{
  # count number of given DBs
  count = "${length(var.db_names)}"
  # allocate DB name for each given name
  name = "${var.db_names[count.index]}"
}

# Create User with provided passwords
resource "mysql_user" "users" 
{
  # count number of users
  count = "${length(var.user_pass_map)}"
  # allocate usernames and passwords for each given user
  user = "${element(keys(var.user_pass_map), count.index)}"
  plaintext_password = "${lookup(var.user_pass_map, "${element(keys(var.user_pass_map), count.index)}")}"
  # let terraform know that it must create the db first
  depends_on = ["mysql_database.sunbit"]
}

# Grant users privileges
resource "mysql_grant" "users" 
{
  # count number of users
  count = "${length(var.user_pass_map)}"
  # grant SELECT privilege for each user on all databases
  user = "${element(keys(var.user_pass_map), count.index)}"
  database = "*"
  privileges = ["SELECT"]
  # let terraform know that it must grant AFTER user creation
  depends_on = ["mysql_user.users"]
}
