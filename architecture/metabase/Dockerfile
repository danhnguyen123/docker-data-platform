FROM metabase/metabase:latest

USER root

# Install prerequisites
RUN apk add --no-cache wget

RUN wget https://github.com/starburstdata/metabase-driver/releases/download/4.1.0/starburst-4.1.0.metabase-driver.jar \
    && mv starburst-4.1.0.metabase-driver.jar /plugins