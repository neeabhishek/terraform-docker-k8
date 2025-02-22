variable "aws_region" {
  type    = string
  default = "ap-south-1"
}
variable "aws_az" {
  type = string
  default = "ap-south-1a"
}
variable "aws_iam_access_key" {
  type    = string
  default = ""
}
variable "aws_iam_secret_key" {
  type    = string
  default = ""
}
variable "private_key" {
  type    = string
  default = "private_key_ec2.pem"
}
variable "ec2_ami" {
  type    = string
  default = "ami-00bb6a80f01f03502"
}
variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"

}
variable "vpc_id" {
  type    = string
  default = "vpc-0089cd875921c65ad"
}
variable "cidr_block" {
  default = "0.0.0.0/0"
}
variable "webser_user" {
  description = "Default SSH user (Entirely based on the AMI being used, if its Amazon linux then it would be ec2-user)"
  type        = string
  default     = "ubuntu"
}
variable "result_app_image" {
  type = string
  default = "kodekloud/examplevotingapp_result:v1"
}
variable "voting_app_image" {
  type = string
  default = "kodekloud/examplevotingapp_vote:v1"
}
variable "worker_app_image" {
  type = string
  default = "kodekloud/examplevotingapp_worker:v1"
}
