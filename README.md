# FROMGOTOK8S

This GitHub page is used mostly to be used as a static public Chartmuseum

To build the helm package to add it to the static chartmuseum
```sh
helm package fromgotok8s
```

To generate the needed index.yaml page  
```sh
helm repo index .
```

To make use of the static public Chartmuseum
```sh
helm init
helm repo add static-gallo-cedrone-repo https://gallo-cedrone.github.io/fromgotok8s
helm repo update
```