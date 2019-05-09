FROM ubuntu:18.04

# install packages
RUN apt update &&\
    apt install git curl python -y


ENV APP_DIR /home/ubuntu

RUN mkdir $APP_DIR &&\ 
    useradd -d $APP_DIR ubuntu &&\
    chown -R ubuntu $APP_DIR
WORKDIR $APP_DIR
RUN rm /bin/sh &&\
    ln -s /bin/bash /bin/sh
USER ubuntu


# Install specific version of Node.js
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
ENV NODE_VERSION 10.15.3
RUN . .nvm/nvm.sh &&\
    nvm install $NODE_VERSION &&\
    nvm alias default $NODE_VERSION &&\
    nvm use default
ENV NODE_PATH $APP_DIR/.nvm/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $APP_DIR/.nvm/versions/node/v$NODE_VERSION/bin:$PATH



RUN npm install -g pm2

RUN mkdir WMAS && cd WMAS && git init && git remote add origin https://github.com/cta-wave/WMAS.git
WORKDIR WMAS

ARG commit

RUN git fetch origin $commit
RUN git reset --hard FETCH_HEAD

RUN ./wave init
RUN ./wmats2018-subset.sh
RUN ./wave download-reference-results
RUN mv results reference-results

CMD cp -r ./reference-results/* /home/ubuntu/results && pm2 start ./wpt --interpreter python -- serve && ./wave start
