# kpt

links:

- https://kpt.dev/
- https://skaffold.dev/docs/pipeline-stages/renderers/kpt/

pros:

-

cons:

-

## adding new instances

```
$ kpt pkg get https://github.com/damlys/kube.git/kpt/packages/kuard@master instances/kuard-test
$ kpt fn render instances/kuard-test
$ kpt pkg update instances/kuard-test@master

$ kpt live init instances/kuard-test
$ kpt live apply instances/kuard-test
$ kpt live status instances/kuard-test
$ kpt live destroy instances/kuard-test
```

## 101

```
$ kubectl create namespace playground-kpt

$ skaffold render --profile=test --output=.skaffold-render/test.yaml
$ skaffold render --profile=prod --output=.skaffold-render/prod.yaml

$ skaffold run --profile=test --port-forward
$ skaffold run --profile=prod --port-forward

$ skaffold delete --profile=test
$ skaffold delete --profile=prod
```
