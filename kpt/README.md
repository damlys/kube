# kpt

links:

- https://kpt.dev/
- https://skaffold.dev/docs/pipeline-stages/renderers/kpt/

pros:

-

cons:

-

## 101

```
$ kubectl create namespace playground-kpt

$ kpt pkg get https://github.com/damlys/kube.git/kpt/packages/kuard@639ebdd6a3e7f44fb39cd4bb15254dc5d7ecb1c1 instances/kuard-test
$ kpt fn render instances/kuard-test
$ kpt pkg update instances/kuard-test@3a56111b0a43510b4788335ad10637f708b6d75c

$ kpt live apply instances/kuard-test
$ kpt live status instances/kuard-test
$ kpt live destroy instances/kuard-test
```
