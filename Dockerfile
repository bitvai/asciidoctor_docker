FROM ubuntu:20.04

MAINTAINER Bitvai Csaba

ENV PLANTUML_VERSION=1.2021.0

RUN apt-get update  \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y locales tzdata \
  && apt-get install -y --no-install-recommends asciidoctor \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN  gem install --no-document asciidoctor \
  && gem install --no-document asciidoctor-pdf \
  && gem install --no-document asciidoctor-diagram \
  && gem install --no-document rouge coderay pygments.rb thread_safe \
  && gem install --no-document asciidoctor-revealjs \
  && gem install --no-document asciidoctor-rouge \
  && gem install --no-document asciidoctor-question 
  
RUN apt-get update && apt-get install -y git nodejs npm \
  && mkdir /wavedrom-cli \
  && git clone https://github.com/wavedrom/cli.git /wavedrom-cli \
  && npm install wavedrom-cli --save-dev \
  && ln -s /node_modules/wavedrom-cli/wavedrom-cli.js /usr/local/bin/wavedrom-cli \
  && apt-get remove -y git npm \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* 
  
RUN apt-get update \
  && apt-get install -y --no-install-recommends openjdk-11-jre-headless graphviz wget \
  && wget "http://downloads.sourceforge.net/project/plantuml/${PLANTUML_VERSION}/plantuml.${PLANTUML_VERSION}.jar" -O /usr/local/bin/plantuml.jar \
  && apt-get remove -y wget \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
  
ADD plantuml /usr/local/bin/

RUN chmod 0755 /usr/local/bin/plantuml


RUN du --summarize -h 2>/dev/null; exit 0
  
WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
