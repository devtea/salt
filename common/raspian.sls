{% from "common/map.jinja" import common with context %}

pi_cleanup:
  user.absent:
    - name: pi
    - purge: true
