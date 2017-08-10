{% set url = salt['pillar.get']('java-app:autodeploy-url') %}

print_output:
  cmd.run:
    - name: echo "printing url {{ url }}"
