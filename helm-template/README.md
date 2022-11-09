# helm-template

links:

- https://helm.sh/
- https://helm.sh/docs/helm/helm_template/
- https://skaffold.dev/docs/pipeline-stages/renderers/helm/

pros:

-

cons:

-

## 101

```
$ kubectl create namespace playground-helm

$ skaffold render --profile=test --output=.skaffold-render/test.yaml
$ skaffold render --profile=prod --output=.skaffold-render/prod.yaml

$ skaffold run --profile=test --port-forward
$ skaffold run --profile=prod --port-forward

$ skaffold delete --profile=test
$ skaffold delete --profile=prod
```
