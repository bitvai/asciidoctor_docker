FROM ubuntu:20.04

MAINTAINER Bitvai Csaba

ENV ASCIIDOCTOR_VERSION=2.0.12 \
  ASCIIDOCTOR_PDF_VERSION=1.5.4 \
  ASCIIDOCTOR_DIAGRAM_VERSION=2.1.0 \
  ASCIIDOCTOR_REVEALJS_VERSION=4.1.0 \
  ASCIIDOCTOR_BIBTEX_VERSION=0.8.0 \
  ASCIIDOCTOR_ROUGE_VERSION=0.4.0 \
  DIAGRAM_PLANTUML_CLASSPATH=/usr/local/bin/plantuml.jar
  
ENV PLANTUML_VERSION=1.2021.4

RUN apt-get update  \
  && DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y locales tzdata openjdk-8-jre-headless graphviz asciidoctor wget \
  && wget "http://downloads.sourceforge.net/project/plantuml/${PLANTUML_VERSION}/plantuml.${PLANTUML_VERSION}.jar" -O /usr/local/bin/plantuml.jar
  
RUN  gem install --no-document \
    "asciidoctor:${ASCIIDOCTOR_VERSION}" \
    "asciidoctor-diagram:${ASCIIDOCTOR_DIAGRAM_VERSION}" \
	"asciidoctor-pdf:${ASCIIDOCTOR_PDF_VERSION}" \
    "asciidoctor-revealjs:${ASCIIDOCTOR_REVEALJS_VERSION}" \
	"asciidoctor-bibtex:${ASCIIDOCTOR_BIBTEX_VERSION}" \
    "asciidoctor-rouge:${ASCIIDOCTOR_ROUGE_VERSION}" \
    coderay \
    haml \
    pygments.rb \
    rouge \
    slim \
    thread_safe \
    tilt \
    text-hyphen

RUN apt-get install -y git nodejs npm \
  && mkdir /wavedrom-cli \
  && git clone https://github.com/wavedrom/cli.git /wavedrom-cli \
  && npm install wavedrom-cli --save-dev \
  && ln -s /node_modules/wavedrom-cli/wavedrom-cli.js /usr/local/bin/wavedrom-cli \
  && apt-get remove -y git npm wget\
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* 

RUN du --summarize -h 2>/dev/null; exit 0
  
WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
