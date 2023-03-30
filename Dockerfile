FROM node:stretch-slim
RUN apt-get update \
 && apt-get install -y git \
 && git clone https://github.com/wavedrom/cli.git /wavedrom-cli \
 && cd /wavedrom-cli && npm install wavedrom-cli --save-dev


FROM ruby:3.2.1-alpine3.17
MAINTAINER Bitvai Csaba

ENV ASCIIDOCTOR_VERSION=2.0.18 \
  ASCIIDOCTOR_PDF_VERSION=2.3.4 \
  ASCIIDOCTOR_DIAGRAM_VERSION=2.2.6 \
  ASCIIDOCTOR_REVEALJS_VERSION=4.1.0 \
  ASCIIDOCTOR_ROUGE_VERSION=0.4.0 \
  ASCIIDOCTOR_MATHEMATICAL_VERSION=0.3.5 \
  DIAGRAM_PLANTUML_CLASSPATH=/usr/local/bin/plantuml.jar
ENV PLANTUML_VERSION=1.2023.5

WORKDIR /node_modules
COPY --from=0 /wavedrom-cli/node_modules .

RUN apk update \
 && apk add --no-cache \
	bash \
	font-bakoma-ttf \
	git \
	graphviz \
	ruby-bigdecimal \
	ruby-mathematical \
	ttf-liberation \
	ttf-dejavu \
	tzdata \
	unzip \
	which \
	nodejs \
	openjdk17-jre \
 && apk add --no-cache --virtual .rubymake \
	build-base \
	wget \
 && gem install --no-document \
    "asciidoctor:${ASCIIDOCTOR_VERSION}" \
    "asciidoctor-diagram:${ASCIIDOCTOR_DIAGRAM_VERSION}" \
	"asciidoctor-pdf:${ASCIIDOCTOR_PDF_VERSION}" \
    "asciidoctor-revealjs:${ASCIIDOCTOR_REVEALJS_VERSION}" \
    "asciidoctor-rouge:${ASCIIDOCTOR_ROUGE_VERSION}" \
    coderay \
    haml \
    pygments.rb \
    rouge \
    slim \
    thread_safe \
    tilt \
    text-hyphen \
 && apk del -r --no-cache .rubymake \
 && wget "http://downloads.sourceforge.net/project/plantuml/${PLANTUML_VERSION}/plantuml-nodot.${PLANTUML_VERSION}.jar" -O /usr/local/bin/plantuml.jar \
 && ln -s /node_modules/wavedrom-cli/wavedrom-cli.js /usr/local/bin/wavedrom-cli

WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
