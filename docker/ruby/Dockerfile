FROM ruby:2.6.3

LABEL Name=point-card-api Version=0.0.1
EXPOSE 3000

#ARG TZ=Asia/Tokyo
#ENV TZ　${TZ}
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -qq \
  && apt-get install -y \
    build-essential \
    nodejs \
    vim \
  && rm -rf /var/lib/apt/lists/*

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

WORKDIR /usr/src/point-card-api
#COPY ./point-card-api /point-card-api

COPY ./point-card-api/Gemfile ./point-card-api/Gemfile.lock ./
RUN bundle install

#CMD ["ruby", "point-api.rb"]
