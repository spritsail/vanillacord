def main(ctx):
  return [
    step("1.17.1"),
    step("1.18-pre8",["latest"]),
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
          "exec_pre": "echo eula=true > eula.txt",
          "log_pipe": "grep -qm 1 \\'Done ([0-9]\\\\+\\\\.[0-9]\\\\+s)\\\\!\\'",
          "timeout": 600,
        },
      },
      {
        "name": "publish",
        "image": "spritsail/docker-publish",
        "pull": "always",
        "settings": {
          "repo": "spritsail/vanillacord",
          "tags": [mcver] + tags,
          "login": {
            "from_secret": "docker_login",
          },
        },
        "when": {
          "branch": ["master"],
          "event": ["push"],
        },
      },
    ]
  }

