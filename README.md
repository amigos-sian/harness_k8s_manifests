# k8s_manifests

Sample Kubernetes deployment and service manifests which can be referenced for services in harness. 

Example apps:

- guestbook
- nginx
- sidecar-example:
    - Deploys nginx as main artifact with 2 busybox sidecars

Syntax Feature:

- In values.yml, notice Harness params can be passed e.g. for namespaces defined under namespace: `<+infra.namespace>`
- Notice is deployment and service files, variables can be referenced like this eg. `{{.Values.namespace}}`.

## Terraform

Harness resources can be managed by terraform. To run this, you will need to specify the following in a backend-tfvars.tf file under `terraform/backend_vars`. 

```
harness_account_id =
harness_platform_api_key =

```

[About Harness tokens](https://developer.harness.io/docs/platform/user-management/add-and-manage-api-keys/)
[More info](https://developer.harness.io/docs/platform/resource-development/terraform/harness-terraform-provider/)
[Examples of Terraform resources](https://developer.harness.io/docs/platform/resource-development/terraform/harness-terraform-provider/)

### Terraform commands

Generate plan
```
tfenv use 1.0.8
cd terraform
terraform init
terraform plan -var-file=./backend_vars/backend-tfvars.tfvars

```

Apply Plan

`terraform apply -var-file=./backend_vars/backend-tfvars.tfvars`

Import resources to state - terraform.tfstate

`terraform import`

Destroy resources

`terraform apply -destroy -var-file=./backend_vars/backend-tfvars.tfvars`

## Cloudformation

In `cloudformation_templates` there's a simple Cloudformation temmplate for provisioning an S3 bucket.

The template example is sourced from [here](https://www.varonis.com/blog/create-s3-bucket)

test change