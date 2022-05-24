# Devops Test

### Overview
This is an application that is a dummy webservice that returns the
last update time.  The last updated time is cached in redis and
resets every 5 seconds.  It has a single '/' endpoint.  The redis
address is passed in through the environment.

NOTE: The following tasks are estimated to take no more than 3 hours total.

### Tasks
1. Create Dockerfile for this application
2. Create docker-compose.yaml to replicate a full running environment 
so that a developer can run the entire application locally without having
to run any dependencies (i.e. redis) in a separate process.
3. Explain how you would monitor this application in production. 
Please write code/scripts to do the monitoring.

### Kubernetes(MiniKube) Tasks
4. Prepare local Kubernetes environment (using MiniKube) to run our application in pod/container. 
Store all relevant scripts (kubectl commands etc) in your forked repository.
5. Suggest & create minimal local infrastructure to perform functional testing/monitoring of our application pod.
Demonstrate monitoring of relevant results & metrics for normal app behavior and failure(s).

Please fork this repository and make a pull request with your changes.

Please provide test monitoring results in any convenient form (files, images, additional notes) as a separate archive.


############### RESULTS #############
1. Dockerfile is created.
2. Docker-compose is created, contains both redis and app services. Makefile can be used to deploy env in 1 command.
3. We can add go metrics via library for Prometheus. And we can add custom metrics and create Grafana dashboards for them. Sample code to expose metrics was added to main.go. 
Also pod should be monitored by CPU/Mem usage and other standard metrics. And alerts can be added to notify on email/slack/telegram/etc if some problems happen.
4. Local environment prepared using Docker on Windows. Kubectl commands are in makefile.
5. Prometheus/Grafana installed using helm. I had some issues with local environment and node exporter didn't work fully. I didn't have time to tshoot it unfortunately.
Metrics was added to the image. Scrapper was configured for go-app, and redis-exporter for redis.
We can import some preconfigured dashboards from marketplace like 6671 for go-metrics and 763 for redis exporter metrics. (was shown on screenshots)
