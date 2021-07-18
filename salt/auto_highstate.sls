auto_highstate:
  schedule.present:
    - function: state.highstate test=true
    - seconds: 3600
    - splay: 60
    - maxrunning: 1
    - enabled: true
