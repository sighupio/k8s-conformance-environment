# K8S Conformance Environment

This project contains a terraform module to create basic Kubernetes clusters to run CNCF Conformance tests.
Also, there are three different terraform projects to create three diferent Kubernetes cluster *(different versions)*
to run CNCF conformance e2e tests on top of it.


## Terraform modules


### aws-k8s-conformance

The [`aws-k8s-conformance`](modules/aws-k8s-conformance) creates an opinionated Kubernetes Cluster
to run CNCF Conformance tests.


## Fury Conformance Tests

[This directory](fury/) contains different terraform projects using the
[`aws-k8s-conformance`](modules/aws-k8s-conformance) to create the neccessary
environments to run the CNCF Conformance e2e tests. You can see more information [here](fury/)


## License

For license details please see [LICENSE](./LICENSE)
