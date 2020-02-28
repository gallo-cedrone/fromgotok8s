### FROMGOTOK8s

This project implements a proof of concept of a complete CI/CD for a golang project making use of the following tools:

 - travis to build/release/deploy
 - unit Testing
 - integration tests with dockerCompose
 - GCP to host a k8s cluster
 - Helm to deploy different releases (I should point to different namespace)
 - DockerHub to host built images
 - Github Pages to host static helm chartmuseum
 - codecov to test coverage
 - viper to deal with configs

Nice to add:

 - snyk to check vulnerabilities
 - terraform?
 - generate automatically rpm an push it to github
 - generate automatically a release notes with commitizen

 - change example to avoid yes.....?