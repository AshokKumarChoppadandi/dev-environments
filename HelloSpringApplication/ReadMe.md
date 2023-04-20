Helm Commands:

Create Chart:

```
helm create hello-spring-app-chart
```

Validate Chart:

```
cd hello-spring-app-chart
helm lint .
``` 

Substitute Values:

```
helm template .
```

Dry-run:

```
cd ../
helm install --dry-run first-release hello-spring-app-chart
```

Chart Status:

```
helm status first-release
```

Upgrade Helm Chart:

```
helm upgrade first-release hello-spring-app-chart
```

Uninstall Helm Chart:

```
helm uninstall first-release
```

Package Helm Chart:

```
helm package hello-spring-app-chart -d hello-spring-app-chart/charts
```

Index Helm Chart:

```
helm repo index hello-spring-app-chart/charts
```

Adding Helm Repository:

```
helm repo add ashokkumarchoppadandi  https://ashokkumarchoppadandi.github.io/dev-environments/HelloSpringApplication/src/main/helm/charts
```

Install Helm Chart From Repository:

```
helm install hello-spring-app ashokkumarchoppadandi/hello-spring-app-chart
```