FROM openjdk:8-jdk


# Script to fix user host permissions
ADD startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh


RUN mkdir /project
WORKDIR /project


# Install development tools
ENV LEIN_ROOT=1
RUN cd /usr/local/bin/ && wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod +x ./lein
RUN lein


# Expose the web and REPL ports
EXPOSE 8080
EXPOSE 9090
