FROM openjdk:18-slim-bullseye

WORKDIR /metabase

COPY ./metabase.jar /metabase/

RUN apt-get update && apt-get install -y --no-install-recommends wget

CMD ["java", "-jar", "metabase.jar"]
