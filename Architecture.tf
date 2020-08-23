provider "aws" {
	region = "ap-south-1"
	profile = "abhinav"
	}
	
	//---------------------------------------------------
	#create vpc
	resource "aws_vpc" "main" {
	cidr_block = "192.168.0.0/16"
	instance_tenancy = "default"
	enable_dns_hostnames = "true"
	tags = {
	Name = "newvpc"
	}
	}
	
	//---------------------------------------------------------
	#create private subnet
	resource "aws_subnet" "privateSn" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "192.168.0.0/24"
	availability_zone = "ap-south-1a"
	
	tags = {
	Name = "pvtsubnet"
	}
	}
	
	//-----------------------------------------------------
	
	#create public subnet
	resource "aws_subnet" "publicSn" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "192.168.1.0/24"
	availability_zone = "ap-south-1b"
	map_public_ip_on_launch = true
	
	tags = {
	Name = "pubsubnet"
	}
	}
	
	//------------------------------------------------------
	#create IG
	resource "aws_internet_gateway" "gw" {
	vpc_id = "${aws_vpc.main.id}"
	
	tags = {
	Name = "newintgw"
	}
	}
	
	//----------------------------------------------------------
	# create vpc routing and add into IG
	resource "aws_route_table" "vpcRouteTable" {
	vpc_id = "${aws_vpc.main.id}"
	
	route {
	cidr_block = "0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.gw.id}"
	}
	
	
	tags = {
	Name = "newroute"
	}
	}
	
	//--------------------------------------------------------------------------------
	# add two subnet into routing table
	
	resource "aws_route_table_association" "associate" {
	subnet_id = "${aws_subnet.publicSn.id}"
	route_table_id = "${aws_route_table.vpcRouteTable.id}"
	}
	
	//---------------------------------------------------------
	#create Security group
	resource "aws_security_group" "mywpsg" {
	name = "wp"
	description = "Allow TLS inbound traffic"
	vpc_id = "${aws_vpc.main.id}"
	
	ingress {
	description = "ICMP"
	from_port = 80
	to_port = 0
	protocol = "icmp"
	cidr_blocks = ["0.0.0.0/0"]
	}
	
	ingress {
	description = "http"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
	
	ingress {
	description = "ssh"
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
	
	egress {
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	}
	
	tags = {
	Name = "mywpsg"
	}
	}
	
	//-------------------------------------------------------------
	#create instance for wp
	resource "aws_instance" "wpos" {
	ami = "ami-7e257211"
	instance_type = "t2.micro"
	key_name = "mykey123"
	subnet_id = aws_subnet.publicSn.id
	vpc_security_group_ids = [ aws_security_group.mywpsg.id ]
	tags = {
	Name = "wordpress"
	}
	}
	
	//---------------------------------------------------------------------------------------------
	# add inbound traffic to mysql instance
	
	resource "aws_security_group" "mysqlsg1" {
	name = "basic"
	description = "Allow TLS inbound traffic"
	vpc_id = "${aws_vpc.main.id}"
	
	ingress {
	description = "mysql"
	from_port = 3306
	to_port = 3306
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
	}
	
	//--------------------------------------------------------------------
	#create instance for mysql
	
	resource "aws_instance" "mysqlos" {
	ami = "ami-08706cb5f68222d09"
	instance_type = "t2.micro"
	key_name = "mykey123"
	subnet_id = aws_subnet.privateSn.id
	vpc_security_group_ids = [ aws_security_group.mysqlsg1.id ]
	tags = {
	Name = "mysqlos1"
	}
	}
	
	//------