def main(ctx):
  return [
    step("1.12.2"),
    step("1.14.4"),
    step("1.15.2",["latest"]),
  ]

def step(mcver,tags=[]):
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
        },
      },
      {
        "name": "test",
        "image": "spritsail/docker-test",
        "pull": "always",
        "settings": {
          "repo": "vanillacord-dev-%s" % mcver,
          "exec_pre": "echo eula=true > eula.txt",
          "log_pipe": "grep -qm 1 \\'Done ([0-9]\\\\+\\\\.[0-9]\\\\+s)\\\\!\\'",
          "timeout": 60,
        },
      },
      {
        "name": "publish",
        "image": "spritsail/docker-publish",
        "pull": "always",
        "settings": {
          "from": "vanillacord-dev-%s" % mcver,
          "repo": "spritsail/vanillacord",
          "tags": [mcver] + tags,
        },
        "environment": {
          "DOCKER_USERNAME": {
            "from_secret": "docker_username",
          },
          "DOCKER_PASSWORD": {
            "from_secret": "docker_password",
          },
        },
        "when": {
          "branch": ["master"],
          "event": ["push"],
        },
      },
    ]
  }

