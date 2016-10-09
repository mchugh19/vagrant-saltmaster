jenkins:
  user.present:
    - password: "$1$EKpKvY0d$YnXy//PWiT7u5E2g4hggf/"

salt-api:
  pkg.installed: []
  service.running:
    - require:
      - pkg: salt-api

/etc/salt/master.d/saltapi.conf:
  file.managed:
    - source: salt://saltapi/files/saltapi.conf
    - watch_in:
      - service: salt-master
      - service: salt-api

salt-master:
  service.running

