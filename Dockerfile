FROM spritsail/alpine:edge

ARG MC_VER=1.18-pre6
LABEL maintainer="Spritsail <minecraft@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Minecraft server" \
      org.label-schema.url="https://minecraft.net/en-us/download/server/" \
      org.label-schema.description="Minecraft server" \
      org.label-schema.version=${MC_VER}

RUN apk --no-cache add openjdk17-jre nss curl jq && \
    \
    cd /tmp && \
    curl -fsSLO https://src.me1312.net/jenkins/job/VanillaCord/job/master/lastSuccessfulBuild/artifact/artifacts/VanillaCord.jar && \
    java -jar VanillaCord.jar $MC_VER && \
    mv out/$MC_VER-bungee.jar /vanillacord_server.jar && \
    \
    rm -rf /tmp/* && \
    apk --no-cache del jq

WORKDIR /mc

ENV INIT_MEM=1G \
    MAX_MEM=4G \
    SERVER_JAR=/vanillacord_server.jar

CMD exec java "-Xms$INIT_MEM" "-Xmx$MAX_MEM" -jar "$SERVER_JAR" nogui
