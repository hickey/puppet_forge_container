# FROM ghickey/puppet-forge:1.9.0
FROM ruby:2.4
MAINTAINER "Gerard Hickey <hickey@kinetic-compute.com>"

WORKDIR /usr/src/app
RUN git clone https://github.com/unibet/puppet-forge-server.git . && \
    git checkout -b current 1.9.0 && \
    bundle install && \
    groupadd forge && useradd -g forge forge && \
    mkdir -m 755 /puppet && mkdir -m 775 /puppet/modules && chown -R forge:forge /puppet
ADD entrypoint.rb .
ADD README.md .

USER forge
EXPOSE 8080

ENTRYPOINT ["ruby", "entrypoint.rb"]