Story: Deploying a 3 tier application (java based web application, in-memory database, and postgres on K8 pods with number of replicas as 1).

Infrastructure (Within a VPC and Internet gateway acess to avoid VPN): EC2, Docker, K8 single cluster, Redis, Postgres on Ubuntu

Requirement: IaC needs to be utlized for provisioning, entire source code along with definition files needs to be version controlled on Git.

TechStack: Terraform, Jenkins, K8, docker, Git.

Containers: Voter-App, Result-App, Redis, and Postgres

Terraform Docs for reference:
1.https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#attribute-reference
2.https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key
3.https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
4.https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
5.https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
6.https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl
7.https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
8.https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
9.https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
10.https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
11.https://developer.hashicorp.com/terraform/language/resources/provisioners/file#file-provisioner
12.https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec
13.https://developer.hashicorp.com/terraform/language/resources/provisioners/connection
14.https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
15.https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment#example-usage
