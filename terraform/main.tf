terraform {
  required_providers {
    harness = {
      source = "harness/harness"
    }
  }
}

provider "harness" {  
    endpoint   = "https://app.harness.io/gateway"  
    account_id = var.harness_account_id
    platform_api_key = var.harness_platform_api_key
}

# examples from here - https://developer.harness.io/docs/platform/resource-development/terraform/harness-terraform-provider/

# resource "harness_platform_organization" "org" {​  
#     name      = "Terraform Example Org"  
#     identifier = "terraform_example_org"  
#     description = "Demo Organization, created through Terraform"  
# }

resource "harness_platform_project" "project" {  
    name      = "test project"  
    identifier = "test_project"  
    org_id    = "default"
}

# resource "harness_platform_secret_text" "textsecret" {​  
#     identifier  = "terraform_example_secret"  
#     name        = "Terraform Example Secret"  
#     description = "This is a text Secret, generated through Terraform"  
#     org_id      = "terraform_example_org"  
#     project_id  = "terraform_test_project"  
#     tags        = ["example:tags"]  
  
#     secret_manager_identifier = "harnessSecretManager"  
#     value_type                = "Inline"  
#     value                     = "secret"  
#     lifecycle {  
#         ignore_changes = [  
#             value,  
#         ]  
#     }  
# }

# resource "harness_platform_pipeline" "approval_pipeline" {  
#     identifier  = "approval_pipeline"  
#     name        = "Approval Pipeline"  
#     description = "Simple Approval Stage pipeline generated through Terraform"  
#     project_id  = "terraform_test_project"  
#     org_id      = "terraform_example_org"  
  
#     yaml        = <<PIPETEXT  
#     pipeline:  
#         name: "Approval Pipeline"  
#         identifier: "Approval_Pipeline"  
#         projectIdentifier: "terraform_test_project"  
#         orgIdentifier: "terraform_example_org"  
#         tags: {}  
#         stages:  
#              - stage:  
#                 name: Approval  
#                 identifier: Approval  
#                 description: ""  
#                 type: Approval  
#                 spec:  
#                     execution:  
#                         steps:  
#                             - step:  
#                                 name: Approval Step  
#                                 identifier: Approval_Step  
#                                 type: HarnessApproval  
#                                 timeout: 1d  
#                                 spec:  
#                                     approvalMessage: Please review the following information and approve the pipeline progression  
  
# includePipelineExecutionHistory: true  
#                                     approvers:  
#                                         minimumCount: 1  
# disallowPipelineExecutor: false  
#                                         userGroups:  
#                                             - account.testmv  
#                                     approverInputs: []  
#                     tags: {}  
# PIPETEXT  
# }