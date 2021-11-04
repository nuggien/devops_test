# Devops Test

### Overview
This is an application that is a dummy webservice that returns the
last update time.  The last updated time is cached in redis and
resets every 5 seconds.  It has a single '/' endpoint.  The redis
address is passed in through the environment.

NOTE: The following tasks should take no more than 1 hour total.

### Tasks
1. create Dockerfile for this application
2. create docker-compose.yaml to replicate a full running environment 
so that a developer can run the entire application locally without having
to run any dependencies (i.e. redis) in a separate process.
3. Explain how you would monitor this application in production. Please write code/scripts to do the monitoring.


### Kubernetes(MiniKube) Tasks
1. Prepare local Kubernetes environment (using MiniKube) to run our application in pod/container. Store all relevant scripts (kubectl commands etc) in your forked repository.
2. Suggest & create minimal local infrastructure to perform functional testing/monitoring of our application pod. Demonstrate monitoring of relevant results & metrics for normal app behavior and failure(s).



Please fork this repository and make a pull request with your changes.

Please provide test monitoring results in any convenient form (files, images, additional notes) as a separate archive.



## Solution

1. Dockerfile: ./src/Dockerfile
2. For developer:
```sh
# To see the docker compose manifest
cat docker-compose.yaml
# Start
docker compose up
# Stop
docker compose down
```

3. Application monitoring.
Mostly depends on metrics what we want.
I suggest:
  - add functionality to write logs to the file
  - mount disk
  - run sidecar container with filebeat/metricbeat or fluentd and push logs to the some storage(e.g. InfluxDB)
  - Grafana as UI. Grafana might be used from kube-prometheus-stack(see below)


4. Kubernetes.
I implemented configuration using Helm. Of course it might be only kubectl.
Helm chart: ./k8s

4.1 Create namespace for application

```sh
kubectl create namespace test-app
```

4.2 Deploy ingress-nginx(or similar) if you don't have any ingress controllers
```sh
cd ingress-nginx/
helm install -n test-app ingress-nginx .
```

4.3 Deploy application
```sh
cd ./k8s/deploy/
helm install -n test-app test-app .
# if you have some changes:
helm upgrade -n test-app test-app .
```

You can specify the images in values file: ./k8s/deploy/values.yaml

5. k8s cluster monitoring

5.1 Create monitoring namespace:
```sh
kubectl create namespace monitoring
```

5.2 Deploy kube-prometheus-stack
By default it will deploy prometheus, alert manager, grafana.
You could flexible customize the configuration and add some additional alerts in values file: ./k8s/kube-prometheus-stack/values.yaml

```sh
cd ./k8s/kube-prometheus-stack
helm install -n monitoring monitoring .
```

6. Grafana
There are a lot of pre-defined dashboards.

For instance: http://localhost/grafana/d/6581e46e4e5c7ba40a07646395ef7b23/kubernetes-compute-resources-pod?orgId=1&refresh=10s&var-datasource=Prometheus&var-cluster=&var-namespace=test-app&var-pod=test-app-app-deployment-7ddd5f94fb-2b4j7&from=now-5m&to=now

7. Routing
"/" - application
"/prometheous"
"/grafana"

