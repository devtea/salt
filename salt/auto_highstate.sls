auto_highstate:
  schedule.present:
    - function: state.highstate
    - seconds: 3600
    - splay: 60
    - maxrunning: 1
    - enabled: true
