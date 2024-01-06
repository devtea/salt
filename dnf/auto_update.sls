auto_update:
  schedule.present:
    - function: state.sls
    - job_args:
      - dnf.update
    - when: 1:00am
    - splay: 60
    - maxrunning: 1
    - enabled: true
