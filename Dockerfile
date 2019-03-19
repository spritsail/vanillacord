FROM spritsail/alpine:3.8

ARG MC_VER=1.13.2
LABEL maintainer="Spritsail <minecraft@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Minecraft server" \
      org.label-schema.url="https://minecraft.net/en-us/download/server/" \
      org.label-schema.description="Minecraft server" \
      org.label-schema.version=${MC_VER}

RUN apk --no-cache add openjdk8-jre nss curl jq && \
    \
    cd /tmp && \
    curl -fsSL -o vanillacord.jar \
        https://src.me1312.net/jenkins/job/VanillaCord/job/1.12/lastSuccessfulBuild/artifact/artifacts/VanillaCord.jar && \
    mkdir in && \
    \
    curl -fsSL https://launchermeta.mojang.com/mc/game/version_manifest.json \
        | jq -r ".versions[] | select(.id == \"$MC_VER\") | .url" \
        | xargs curl -fsSL \
        | jq -r ".downloads.server.url" \
        | xargs curl -fsSL -o in/$MC_VER.jar && \
    \
    java -jar vanillacord.jar $MC_VER && \
    mv out/$MC_VER-bungee.jar /vanillacord_server.jar && \
    \
    rm -rf /tmp/* && \
    apk --no-cache del jq

WORKDIR /mc

ENV INIT_MEM=1G \
    MAX_MEM=4G \
    SERVER_JAR=/vanillacord_server.jar

CMD exec java "-Xms$INIT_MEM" "-Xmx$MAX_MEM" -jar "$SERVER_JAR" nogui
