auto_update:
  schedule.present:
    - function: state.apply 
    - job_args:
      - dnf.update
    - when: 1:00am
    - splay: 60
    - maxrunning: 1
    - enabled: true
