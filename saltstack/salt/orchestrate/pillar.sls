{% set variable1 = pillar.get('key1', {}) -%}
{% set variable2 = pillar.get('key2', {}) -%}

check_pillar:
  salt.function:
    - name: cmd.run
    - tgt: 'master'
    - arg:
      - echo got {{ variable1 }} and {{ variable2 }}
