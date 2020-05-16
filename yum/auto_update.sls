auto_update:
  schedule.present:
    - function: state.apply 
    - job_args:
      - yum.update
    - when: 
      - Monday 1:00am
      - Tuesday 1:00am
      - Wednesday 1:00am
      - Thursday 1:00am
      - Friday 1:00am
      - Saturday 1:00am
      - Sunday 1:00am
    - splay: 60
    - maxrunning: 1
    - enabled: true
