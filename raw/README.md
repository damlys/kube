# raw

links:

- https://kubectl.docs.kubernetes.io/references/kubectl/apply/
- https://skaffold.dev/docs/pipeline-stages/renderers/rawyaml/

pros:

-

cons:

-

## 101

```
$ kubectl create namespace playground-raw

$ skaffold render --profile=test --output=.skaffold-render/test.yaml
$ skaffold render --profile=prod --output=.skaffold-render/prod.yaml

$ skaffold run --profile=test --port-forward
$ skaffold run --profile=prod --port-forward

$ skaffold delete --profile=test
$ skaffold delete --profile=prod
```
