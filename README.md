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

* Obtain the following values:

  The public IP address of the web server execute:

  ```bash
   terraform output -raw vm_ip
  ```

  Use this IP to configure the host in ansible hosts.yml file.

  We also need the ACR username and password as environment variables to connect from ANnsible successfully:

  ```bash
   terraform output -raw acr_username
   export ACR_USERNAME=
   terraform output -raw acr_password
   export ACR_PASSWORD=
  ```


* Add remote host to list of known host, so we can connect from local:

  ```bash
    ssh -i /home/cgarcia/.ssh/id_ed25519 cgb@172.201.212.108
  ```

* Manage configuration and deploy applications using Ansible:

  ```bash
   ansible-playbook -i hosts.yml playbook.yml -vvv
  ```

* Once it's done, we can access nginx using PUBLIC_IP:80 and see the index.html page with the message: 
  Hello World - Nginx - Podman Demo


* Clean up the resources created.
  
  Run command:

  ```bash
  terraform destroy
  ```