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

$ kpt pkg update kuard-prod
$ kpt fn render kuard-prod

$ kpt live apply kuard-prod
$ kpt live status kuard-prod
$ kpt live destroy kuard-prod
```
