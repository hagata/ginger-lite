FROM debian:wheezy

RUN apt-get update
RUN apt-get upgrade -y && \
      apt-get install -y sudo \
                            git \
                            curl \
                            wget \
                            unzip \
                            python \
                            python-imaging \
                            python-numpy \
                            python-dev \
                            python-pip \
                            build-essential

RUN curl -sl https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs

# Install APPENGINE SDK

RUN wget https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.27.zip
RUN unzip google_appengine_1.9.27.zip 
RUN rm google_appengine_1.9.27.zip
ENV PATH=$PATH:/google_appengine/

ADD package.json app/

WORKDIR app/

RUN npm install

CMD dev_appserver.py . --host=0.0.0.0 \
                          --admin_host=0.0.0.0 \
                          --skip_sdk_update_check \
                          --use_mtime_file_watcher

