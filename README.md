# High-Level-Architecture  


Fully automated proccess by Terraform ,it create a high level of sysytem of website and databases with highest level of security,
this is an example of wordpress(blog website) and its database interconnected but can be implemented in any system 
# Description
I have to create a web portal for a company with all the security as much as possible.
So, we use Wordpress software with dedicated database server.
The Database is not  accessible from the outside world for security purposes.
the only need for public is WordPress to clients.

So here are the steps for proper understanding!

# Steps:
1) Written a Infrastructure as code using terraform, which automatically create a VPC.

2) In that VPC we have to create 2 subnets:
    a)  public  subnet [ Accessible for Public World! ] 
    b)  private subnet [ Restricted for Public World! ]

3) Created a public facing internet gateway for connect our VPC/Network to the internet world and attach this gateway to our VPC.

4) Created  a routing table for Internet gateway so that instance can connect to outside world, update and associate it with public subnet.

5) Launched an ec2 instance which has Wordpress setup already having the security group allowing  port 80 so that our client can connect to our wordpress site.
Also attach the key to instance for further login into it.

6) Launch an ec2 instance which has MYSQL setup already with security group allowing  port 3306 in private subnet so that our wordpress vm can connect with the same.
Also attached the key with the same.

Note: 
Wordpress instance is be part of public subnet so that our client can connect our site. 
MySql instance is a part of private subnet so that outside world can't connect to it
