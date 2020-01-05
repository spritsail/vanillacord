def main(ctx):
  return [
    step("1.12.2"),
#    step("1.13.2"),
#    step("1.14.4"),
#    step("1.15.1", ["latest"]),
  ]

def step(mcver,tags=[]):
  tags = tags + ["%label org.label-schema.version"]
  return {
    "kind": "pipeline",
    "name": "build-%s" % mcver,
    "steps": [
      {
        "name": "build",
        "image": "spritsail/docker-build",
        "pull": "always",
        "settings": {
          "repo": "vanillacord-dev-%s" % mcver,
          "build_args": [
            "MC_VER=%s" % mcver,
          ],
        }
      },
      {
        "name": "test",
        "image": "spritsail/docker-test",
        "pull": "always",
        "settings": {
           "repo": "vanillacord-dev-%s" % mcver,
           "verbose": "true",
           "exec_pre": "echo eula=true > eula.txt",
           "timeout": "60",
           "log_pipe": "grep -qm 1 \\'\\\\[Server thread/INFO\\\\]. Done ([0-9]\\\\+\\\\.[0-9]\\\\+s)\\\\!\\\\'",
        }
      },
#      {
#        "name": "publish",
#        "image": "spritsail/docker-publish",
#        "pull": "always",
#        "settings": {
#          "from": "vanillacord-dev-%s" % mcver,
#          "repo": "spritsail/vanillacord",
#          "tags": tags,
#        },
#        "environment": {
#          "DOCKER_USERNAME": {
#            "from_secret": "docker_username",
#          },
#          "DOCKER_PASSWORD": {
#            "from_secret": "docker_password",
#          },
#        },
#        "when": {
#          "branch": [ "master" ],
#          "event": [ "push"],
#        },
#      },
    ],
  }
