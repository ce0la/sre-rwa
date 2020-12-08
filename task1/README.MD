# Instructions

## Prerequisites
1. Free tier AWS account
2. Public github repository

## Inputs
As an input you are provided with an index.html file.

## Task
Using Infrastructure as a Code (use language and tools of your choice) deploy index.html file to AWS cloud.

## Output
1. Put the code to github repositry under task1/ folder
2. Put the screenshot proving (screenshot1.png) that application runs on AWS into the folder 


# Setup
> Code was tested using terraform 0.14, so ensure you have it installed

1. Run the following commands in Linux terminal:
```
terraform init  # to initialise the directory containing the terraform config files
terraform plan  # to visually outline the resources that will be created modified or destroyed
terraform apply  # to actually create the resources outlined above
```
2. Copy the address contained in the output "DNS" line and enter into a browser to display the "Hello World" page
