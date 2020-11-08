FROM ruby:2.7.2

#RUN curl https://deb.nodesource.com/setup_12.x | bash
#RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
#RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && \
    apt-get install -y build-essential \ 
                       libpq-dev \        
                       nodejs

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

ENV MYSQL_VERSION 8.0.18
RUN apt install -y lsb-release \ 
    && apt remove -y libmariadb-dev-compat libmariadb-dev

RUN wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-common_${MYSQL_VERSION}-1debian10_amd64.deb \
    https://dev.mysql.com/get/Downloads/MySQL-8.0/libmysqlclient21_${MYSQL_VERSION}-1debian10_amd64.deb \
    https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-community-client-core_${MYSQL_VERSION}-1debian10_amd64.deb \
    https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-community-client_${MYSQL_VERSION}-1debian10_amd64.deb \
    https://dev.mysql.com/get/Downloads/MySQL-8.0/libmysqlclient-dev_${MYSQL_VERSION}-1debian10_amd64.deb

RUN dpkg -i mysql-common_${MYSQL_VERSION}-1debian10_amd64.deb \
    libmysqlclient21_${MYSQL_VERSION}-1debian10_amd64.deb \
    mysql-community-client-core_${MYSQL_VERSION}-1debian10_amd64.deb \
    mysql-community-client_${MYSQL_VERSION}-1debian10_amd64.deb \
    libmysqlclient-dev_${MYSQL_VERSION}-1debian10_amd64.deb

RUN mkdir -p /app/cesped
ENV APP_ROOT /app/cesped
WORKDIR ${APP_ROOT}

ENV NODE_ENV "development"

ADD Gemfile ${APP_ROOT}/Gemfile
ADD Gemfile.lock ${APP_ROOT}/Gemfile.lock
RUN bundle install --path=/usr/local/bundle

RUN yarn install --check-files

ADD . ${APP_ROOT}
