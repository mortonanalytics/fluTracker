FROM r-base:3.6.3

RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libgit2-dev libssh2-1-dev libssl-dev libxml2-dev make pandoc pandoc-citeproc zlib1g-dev && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
sudo \
gdebi-core \
libcurl4-gnutls-dev \
libcairo2-dev/unstable \
libxt-dev 

RUN R -e "install.packages(c('shiny', 'shinyWidgets', 'htmltools', 'assertthat', 'yaml', 'devtools' 'htmlwidgets', 'dplyr', 'viridis' ), repos='http://cran.rstudio.com/')"

RUN Rscript -e 'devtools::install_github("mortonanalytics/myIO")'
RUN Rscript -e 'devtools::install_github("mortonanalytics/myGIO")'

COPY /app /app/

EXPOSE 80
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0'); shiny::runApp('app')"
