# kpt

links:

- https://kpt.dev/
- https://skaffold.dev/docs/pipeline-stages/renderers/kpt/

pros:

-

cons:

-

## pkg

```
$ kpt pkg get https://github.com/damlys/kube.git/kpt/packages/kuard@main instances/kuard-test
$ kpt pkg get https://github.com/damlys/kube.git/kpt/packages/kuard@main instances/kuard-prod

$ kpt pkg update instances/kuard-test@main
$ kpt pkg update instances/kuard-prod@main
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
