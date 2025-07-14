# Terraform first attempt

This folder contains a first attempt of a [Terraform](https://www.terraform.io/) file on Microsoft Azure.

## Using the code

* Configure your access to Azure.

  * Authenticate using the Azure CLI.

    ```bash
    az login  
    ```
 
* Initialize Terraform configuration.

  ```bash
  terraform init
  ```

* Validate the changes.

  ```bash
  terraform validate
  ```

* Create the plan.

  ```bash
  terraform plan
  ```

* Apply the changes.

  ```bash
  terraform apply
  ```

* Obtain the exposed values:

  To get the public IP address of the web server execute terraform output -raw vm_ip. 

  We can connect using this public IP to exposed port 8080 where we should get a `Hello, World` response message.

* Clean up the resources created.
  
  Run command:

  ```bash
  terraform destroy
  ```