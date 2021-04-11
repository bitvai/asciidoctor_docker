FROM node:stretch-slim
RUN apt-get update \
 && apt-get install -y git \
 && git clone https://github.com/wavedrom/cli.git /wavedrom-cli \
 && cd /wavedrom-cli && npm install wavedrom-cli --save-dev


FROM ruby:2.7.3-alpine3.13
MAINTAINER Bitvai Csaba

ENV ASCIIDOCTOR_VERSION=2.0.13 \
  ASCIIDOCTOR_PDF_VERSION=1.5.4 \
  ASCIIDOCTOR_DIAGRAM_VERSION=2.1.0 \
  ASCIIDOCTOR_REVEALJS_VERSION=4.1.0 \
  ASCIIDOCTOR_ROUGE_VERSION=0.4.0 \
  DIAGRAM_PLANTUML_CLASSPATH=/usr/local/bin/plantuml.jar
ENV PLANTUML_VERSION=1.2021.4

WORKDIR /node_modules
COPY --from=0 /wavedrom-cli/node_modules .

RUN apk update \
 && apk --no-cache add bash nodejs graphviz wget openjdk8-jre \
 && wget "http://downloads.sourceforge.net/project/plantuml/${PLANTUML_VERSION}/plantuml.${PLANTUML_VERSION}.jar" -O /usr/local/bin/plantuml.jar \
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
 && ln -s /node_modules/wavedrom-cli/wavedrom-cli.js /usr/local/bin/wavedrom-cli \
 && apk del wget

WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
