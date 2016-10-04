## Build: docker build -t r-check -f simmer/working_dir/r-check.Dockerfile .
##        R CMD build simmer
## Usage: docker run --rm -ti -v $(pwd):/mnt r-check Rdevel CMD check --as-cran /mnt/simmer_x.x.x.tar.gz
## Usage: docker run --rm -ti -v $(pwd):/mnt r-check R CMD check --use-valgrind /mnt/simmer_x.x.x.tar.gz

## Start with the base image
FROM rocker/r-devel-san:latest
MAINTAINER Iñaki Úcar <i.ucar86@gmail.com>

## Set a useful default locale
ENV LANG=en_US.utf-8

## Install dependencies
RUN apt-get install -y \
  libssl-dev
RUN Rscript -e 'install.packages(c("devtools", "MASS", "Rcpp", "BH", "R6", "magrittr", "dplyr", "tidyr", "ggplot2", "scales", "testthat", "knitr", "rmarkdown", "covr"))'
RUN Rscriptdevel -e 'install.packages(c("devtools", "MASS", "Rcpp", "BH", "R6", "magrittr", "dplyr", "tidyr", "ggplot2", "scales", "testthat", "knitr", "rmarkdown", "covr"))'

# Add user
RUN echo 'root:test' | chpasswd \
# && useradd -u 1000 -m docker \
&& echo 'docker:test' | chpasswd \
&& usermod -s /bin/bash docker \
&& usermod -a -G 100 docker \
# && usermod -a -G sudo docker \
# set standard repository
&& cd /home/docker

ENV HOME /home/docker
WORKDIR /home/docker
USER docker
