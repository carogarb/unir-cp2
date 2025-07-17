# Terraform first attempt

This folder contains a first attempt of a [Terraform](https://www.terraform.io/) file on Microsoft Azure.

## Using the code

* Configure your access to Azure.

  * Authenticate using the Azure CLI.

    ```bash
    az login --use-device-code 
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

* Save outputs variables to a temp file, to use them with Ansible:

  ```bash
  terraform output -json > terraform_outputs.json
   chmod 777 terraform_outputs.json
  ```

* Get the VM machine query to use it in hosts.yml file (Ansible):

  ```bash
  terraform output -raw vm_ip
  ```

* Once the file hosts for Ansible is correct, manage configuration and deploy applications using Ansible:

  ```bash
   ansible-playbook -i hosts.yml playbook.yml -vvv
  ```

* When ready, we can access nginx using PUBLIC_IP:80 and see the index.html page with the message: 
  Hello World - Nginx - Podman Demo


* Clean up the resources created.
  
  Run command:

  ```bash
  terraform destroy
  ```