# Ginger-lite
This is a basic Jinja2 boilerplate for use with an app engine instance. 
For convinience, all necessary GAE SDK's and other dependencies are managed through Docker. 
Get started quickly using the docker container with [Docker Toolbox](https://www.docker.com/docker-toolbox)

# getting started

#Running with docker
1. Make sure your docker-machine is running
2. run `make dev` to launch the docker container


# Running without docker
You will need to have the Google App Engine SDK installed

run `npm install` 

# make commands

`make serve` spin up a docker-container and launch the appengine preview server on port:8080. The site is viewable on the `docker-machine.ip:8080` eg. ``192.168.99.100:8080`

# gulp 
Gulp handles building the app to `build/` as well as serving on app engines dev_appserver and deploying to your app engine instance. 

| commands | results |
|--------|-------|
| gulp | default gulp task runs all build tasks followed by initiating watch |
| gulp serve | Launces app engine dev_appserver on port :8080 |
| gulp deploy | deploy from the build directory to your GAE instance. Project name must be specified |
