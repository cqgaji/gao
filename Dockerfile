FROM java:8u45-jre
MAINTAINER "cqgaji"

ADD zdjy/ /usr/local/zdjy
RUN ls /usr/local/zdjy -a
ENV CATALINA_HOME /usr/local/zdjy
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.23
RUN chmod +x /usr/local/zdjy/bin/catalina.sh
RUN chmod +x /usr/local/zdjy/bin/startup.sh
EXPOSE 8080
CMD ["catalina.sh", "run"]