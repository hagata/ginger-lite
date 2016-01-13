#build docker-image
docker-build:
	docker build -t hagata/ginger-lite .

container:
	docker run -ti -v $(shell pwd)/:/app -p 8080:8080 -p 8000:8000 --name gLite-container hagata/ginger-lite

r:
	docker stop gLite-container
	docker rm gLite-container

hello:
	echo "hello"