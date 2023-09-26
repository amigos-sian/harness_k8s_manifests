#! /bin/bash

NAMESPACE=<+stage.variables.NamespaceName>

# Check if the namespace exists
if kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
  echo "Namespace $NAMESPACE already exists."
else
  # Create the namespace
  kubectl create namespace "$NAMESPACE"
  echo "Namespace $NAMESPACE created."
fi