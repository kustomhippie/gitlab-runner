def main(ctx):
  return [
    testing(ctx),
    notify(ctx),
  ]

def testing(ctx):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'testing',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'steps': [
      {
        'name': 'lint',
        'image': 'toolhippie/yamllint:latest',
        'pull': 'always',
        'commands': [
          'yamllint .',
        ],
      },
      {
        'name': 'kustomize',
        'image': 'toolhippie/kubectl:latest',
        'pull': 'always',
        'commands': [
          'kustomize build .',
        ],
      },
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
        'refs/pull/**',
      ],
    },
  }

def notify(ctx):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'notify',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'clone': {
      'disable': True,
    },
    'steps': [
      {
        'name': 'execute',
        'image': 'plugins/matrix:1',
        'pull': 'always',
        'settings': {
          'username': {
            'from_secret': 'matrix_username',
          },
          'password': {
            'from_secret': 'matrix_password',
          },
          'roomid': {
            'from_secret': 'matrix_roomid',
          },
        },
      },
    ],
    'depends_on': [
      'testing',
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
      ],
      'status': [
        'failure',
      ],
    },
  }
