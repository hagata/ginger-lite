#build docker-image
docker-build:
	docker build -t hagata/ginger-lite .

serve:
	docker run -td -v $(shell pwd)/:/app -p 8080:8080 -p 8000:8000 --name gLite-container hagata/ginger-lite
