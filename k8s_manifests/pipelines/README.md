# Model Pipelines

Here's some examples of model pipelines for Harness. 

## Model Canary
[Model Canary](./model_canary.yml) provides a generic pipeline for deploying an app to a preprod environment, prior to a deployment to a production environment.

- When you execute the pipeline, you can select for:
a)  a service e.g. `model_guestbook` and you can restrict the allowed values for this `<+input>.default(default).allowedValues(model_guestbook)`
b) `Execute this step if the stage execution is successful thus far` for stages, when you run the pipeline. 

Notice the service is defined at the highest level for the pipeline so it can easily be used by all pipeline stages.

Here are the stages:

1. Create namespace for preprod: `preprod-<+pipeline.variables.service.replace('_', '-')>`
2. Deploy service under preprod namespace to target pre-prod infrastructure: `model_infra_preprod`
3. Approval step
4. Create namespace for prod: `prod-<+pipeline.variables.service.replace('_', '-')>`
5. Deploy service under prod namespace to target prod infrastructure: `model_infra_prod`


The template ref `create_k8s_namespace` refers to a bash script found [here](../../script_templates/create_namespace.sh). Currently, bash scripts can't be referenced from git in Harness. The script requires `NamespaceName` to be defined as a variable in pipeline stages 1 and 4. 

### Notes on JEXL expressions. 

The JEXL expressions e.g. ``preprod-<+pipeline.variables.service.replace('_', '-')>`, help convert `_` to `-` so identfiers in Harness, e.g. for services, can easily be converted to a naming convention required for Kubernetes objects.

Remember to double-check your environment and infra definitions in Harness. It is recommended to define allowed values for Namespaces under the infra definitions `<+input>.default(default).allowedValues(preprod-model-guestbook)`, to explicitly restrict infra targets that services can be deployed to. 



