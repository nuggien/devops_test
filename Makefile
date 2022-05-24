services:
	docker-compose up --build --force-recreate -d

clean:
	docker-compose down -v

services-k8s:
	kubectl create ns go-app || true
	kubectl apply -f k8s/go-app.yml -n go-app

clean-k8s:
	kubectl delete all --all -n go-app

install-helm:
	curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
	sudo apt-get install apt-transport-https --yes
	echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
	sudo apt-get update
	sudo apt-get install helm
	kubectl config view --raw >~/.kube/config

install-prom:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add stable https://charts.helm.sh/stable
	helm repo update
	kubectl create ns monitoring || true
	helm install kube-stack-prometheus prometheus-community/kube-prometheus-stack \
        --set prometheus-node-exporter.hostRootFsMount.enabled=false \
        --set prometheus-node-exporter.hostNetwork=false \
        --set grafana.adminPassword=secret \
        --set prometheus.service.nodePort=30090 \
        --set prometheus.service.type=NodePort \
        --set grafana.service.nodePort=30030 \
        --set grafana.service.type=NodePort \
        --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.enabled=true \
        --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.name=additional-scrape-configs \
        --set prometheus.prometheusSpec.additionalScrapeConfigsSecret.key=prometheus-additional.yaml \
        --namespace monitoring

install-redis-exporter:
	helm install -n monitoring redis-exporter --set "redisAddress=redis://redis.go-app.svc.cluster.local:6379" prometheus-community/prometheus-redis-exporter
	kubectl -n monitoring apply -f k8s/monitoring/service-monitor-redis.yml

install-app-scrapper:
	 kubectl create secret generic additional-scrape-configs --from-file=k8s/monitoring/prometheus-additional.yaml -n monitoring