# tf

links:

- https://www.terraform.io/
- https://developer.hashicorp.com/terraform/language/settings/backends/kubernetes
- https://registry.terraform.io/providers/hashicorp/kubernetes/latest

pros:

-

cons:

-

## 101

```
$ terraform init
$ terraform apply
$ terraform destroy

$ kubectl -n playground-tf port-forward services/kuard-test-http-server 8080:8080
$ kubectl -n playground-tf port-forward services/kuard-prod-http-server 8081:8080
```
