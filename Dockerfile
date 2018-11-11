FROM spritsail/alpine:3.8

ARG MC_VER=1.13.2
LABEL maintainer="Spritsail <minecraft@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Minecraft server" \
      org.label-schema.url="https://minecraft.net/en-us/download/server/" \
      org.label-schema.description="Minecraft server" \
      org.label-schema.version=${MC_VER}

WORKDIR /mc

RUN apk --no-cache add openjdk8-jre curl jq && \
    \
    curl -fsSL https://launchermeta.mojang.com/mc/game/version_manifest.json \
        | jq -r ".versions[] | select(.id == \"$MC_VER\") | .url" \
        | xargs curl -fsSL \
        | jq -r ".downloads.server.url" \
        | xargs curl -fsSL -o /minecraft_server.jar && \
    \
    apk --no-cache del jq

CMD [ "java", "-Xmx4G", "-Xms1G", "-jar", "/minecraft_server.jar", "nogui" ]
