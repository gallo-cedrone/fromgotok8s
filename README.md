### FROMGOTOK8s
[![Build Status](https://travis-ci.org/gallo-cedrone/fromgotok8s.svg?branch=master)](https://travis-ci.org/gallo-cedrone/fromgotok8s)
[![Coverage Status](https://coveralls.io/repos/github/gallo-cedrone/fromgotok8s/badge.svg?branch=master)](https://coveralls.io/github/gallo-cedrone/fromgotok8s?branch=master)
[![Go Report Card](https://goreportcard.com/badge/github.com/gallo-cedrone/fromgotok8s)](https://goreportcard.com/report/github.com/gallo-cedrone/fromgotok8s)

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
 - generate automatically rpm and push it to github
 - generate automatically a release notes with commitizen
 - coveralls
 - change example to avoid yes.....?
 - set properly latest for image and for tag create reference ${BRANCHNAME}${TAG}