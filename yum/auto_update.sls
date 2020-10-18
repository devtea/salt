auto_update:
  schedule.present:
    - function: state.apply 
    - job_args:
      - yum.update
    - when: 1:00am
    - splay: 60
    - maxrunning: 1
    - enabled: true
