kubectl delete secret/ci-secret -n $NAME_SPACE
kubectl create secret docker-registry ci-secret \
  --docker-server=$ECR_REGISTRY \
  --docker-username=AWS \
  --docker-password=$(aws ecr --profile default --region $AWS_DEFAULT_REGION get-login-password) \
  --namespace=$NAME_SPACE
