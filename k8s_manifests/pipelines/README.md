# Model Pipelines

Here's some examples of model pipelines for Harness. 

## Model Rolling

[Model Rolling](./model_rolling.yml) provides a generic pipeline for deploying an app to a preprod environment. In a rolling deployment, pods are incrementally provisioned. 

## Model Canary

[Model Canary](./model_canary.yml) provides a generic pipeline for deploying an app to a preprod environment, prior to a deployment to a production environment.

When you execute the pipeline, you can select for:
- a service e.g. `model_guestbook` and you can restrict the allowed values for this `<+input>.default(default).allowedValues(model_guestbook)`
- `Execute this step if the stage execution is successful thus far` for stages.

Notice the service is defined at the highest level for the pipeline so it can easily be used by all pipeline stages.

Here are the stages:

1. Create namespace for preprod: `preprod-<+pipeline.variables.service.replace('_', '-')>`
2. Deploy service under preprod namespace to target pre-prod infrastructure: `model_infra_preprod`
3. Approval step
4. Create namespace for prod: `prod-<+pipeline.variables.service.replace('_', '-')>`
5. Deploy service under prod namespace to target prod infrastructure: `model_infra_prod`


The template ref `create_k8s_namespace` refers to a bash script found [here](../../script_templates/create_namespace.sh). Currently, bash scripts can't be referenced from git in Harness. The script requires `NamespaceName` to be defined as a variable in pipeline stages 1 and 4. 

## Model Blue-Green

[Model Blue-Green](./model_blue_green.yml) provides a generic pipeline for deploying an app to a preprod environment

Here are the stages:

1. Create namespace : `preprod-<+pipeline.variables.service.replace('_', '-')>`
2. Stage deployment : blue pods are deployed for staged service e.g. `preprod-model-nginx-stage`
3. Approval step : Opportunity to check endpoint for staged service.
4. Swap primary with staged service
5. Approval step: Opportunity to check endpoint for primary service and approve scale down
6. Scale down: Scales down the staged service with the previous version to 0 replicas.

With stage 2, harness will check to see if a "staged" version of the deployment exists e.g.`preprod-model-nginx-stage`, if it doesn't, it will duplicate the service e.g. `preprod-model-nginx` and add the suffix `-stage`. Deployed pods for the service will be considered as `blue`. e.g. `preprod-model-nginx-blue-bf6755648-bqspr`.

If `preprod-model-nginx-stage` already exists, then pod set for the staged service will be assigned the label `harness.io/color: green`. The pod name may look like this e.g. `preprod-model-nginx-green-5b49dcb6b9-gsjwn`. You will also see blue pods listed under the same namespace, which at this stage, would be available to check via the primary service. 

In stage 4, Harness points the primary service e.g. `preprod-model-nginx` to the staged pods and the app version will increment. If it's the first time deployment, the pod set will still be assigned the label `harness.io/color: blue`. 

Harness will also point the staged service to the pod set originally provisoned under the primary service, which has the label `harness.io/color: green`.

In stage 6, we utilize a new Harness feature to scale down the staged service - this is a cost saving measure. This should scale down the staged service, with the label `harness.io/color: blue`. Note, the feature is in beta - the first time I tried this, the green service was scaled down, but this has worked since. 

Tips

You can check the colour assigned to a pod.

`kubectl get pod preprod-model-nginx-blue-bf6755648-kkhbv -n preprod-model-nginx -o json | jq -r '.metadata.labels["harness.io/color"]' `

Also, check after scale down that the pods with the greatest age are terminated. 

## Check endpoint for service deployed with Nodeport type

1. `kubectl get services -A`

Note ports of interest for your service e.g. `80:30569/TCP`

2. `kubectl --namespace preprod-model-nginx port-forward service/preprod-model-nginx 30569:80`

Set up port forward for the service from the cluster to your local machine

3. Access endpoint: http://localhost:30569/

## Notes on JEXL expressions. 

The JEXL expressions e.g. `preprod-<+pipeline.variables.service.replace('_', '-')>`, help convert `_` to `-` so identfiers in Harness, e.g. for services, can easily be converted to a naming convention required for Kubernetes objects.

Remember to double-check your environment and infra definitions in Harness. It is recommended to define allowed values for Namespaces under the infra definitions e.g. `<+input>.default(default).allowedValues(preprod-model-guestbook)`, to explicitly restrict infra targets that services can be deployed to. 



