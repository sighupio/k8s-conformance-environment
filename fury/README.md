# Fury Conformance Environments


## Requirement

To create any of these clusters you should have the following environment variables setup before run `make` commands:

- `AWS_ACCESS_KEY_ID`: The aws access key id with enough permissions to create the cluster
- `AWS_SECRET_ACCESS_KEY`: The secret part of the `AWS_ACCESS_KEY_ID`
- `AWS_DEFAULT_REGION`: Region where cluster will be created
- `TERRAFORM_TF_STATE_BUCKET_NAME`: Bucket where terraform state will be stored
- `TERRAFORM_TF_STATE_KEY`: Terraform state filename/key inside the `TERRAFORM_TF_STATE_BUCKET_NAME`.


### .envrc

You can create a `.envrc` *(direnv)* in this directory with the following content. This will make your life easier.

```bash
#!/bin/bash

export AWS_ACCESS_KEY_ID=YOUR_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_AWS_SECRET_KEY
export AWS_DEFAULT_REGION=eu-whatever

export TERRAFORM_TF_STATE_BUCKET_NAME=BUCKET_WHERE_TO_STORE_STATE
export TERRAFORM_TF_STATE_KEY=conformance-test
```


## Run

Just run `make` to see available commands:

```bash
$ make
 Choose a command run in fury:
 Don't forget to set fury-dir variable 
 Example usage: make init fury-dir=1.16 

  init               Run terraform init command
  plan               Run terraform plan command
  apply              Run terraform apply command
  destroy            Run terraform destroy command
  ssh_command_help   Get Help to ssh
```

As `make` command says, you can start creating a 1.14, 1.15 or 1.16 cluster with the following commands:

```bash
$ make init fury-dir=1.14
$ make plan fury-dir=1.14
$ make apply fury-dir=1.14
.
.
.
Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:

master_public_ip = 52.214.8.39
ssh_command_help = cd 1.14 && terraform output tls_private_key > cluster.key && chmod 400 cluster.key && ssh -i cluster.key fury@52.214.8.39
tls_private_key = <sensitive>
worker_private_ip = [
  "10.100.10.188",
  "10.100.10.233",
]
```

So you can run `cd 1.14 && terraform output tls_private_key > cluster.key && chmod 400 cluster.key && ssh -i cluster.key`
to log into the control plane.

```bash
$ cd 1.14 && terraform output tls_private_key > cluster.key && chmod 400 cluster.key && ssh -i cluster.key fury@52.214.8.39
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-1058-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Feb 17 09:54:03 UTC 2020

  System load:  1.24              Processes:           125
  Usage of /:   1.6% of 96.88GB   Users logged in:     0
  Memory usage: 3%                IP address for ens5: 10.100.0.127
  Swap usage:   0%

0 packages can be updated.
0 updates are security updates.



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

fury@ip-10-100-0-127:~$
```

After a couple of minutes, you will be able to run `kubectl` commands inside the control-plane:

```bash
fury@ip-10-100-0-127:~$ kubectl get nodes
NAME                                          STATUS     ROLES    AGE     VERSION
ip-10-100-0-127.eu-west-1.compute.internal    NotReady   master   2m12s   v1.14.8
ip-10-100-10-188.eu-west-1.compute.internal   NotReady   <none>   112s    v1.14.8
ip-10-100-10-233.eu-west-1.compute.internal   NotReady   <none>   112s    v1.14.8
```
