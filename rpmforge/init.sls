{% if grains['os_family'] == 'RedHat' and grains['osarch'] == 'x86_64' %}

{% if grains['osmajorrelease'][0] == '4' %}
  {% set pkg = {
    'key': 'salt://rpmforge/files/RPM-GPG-KEY.dag.txt',
    'key_hash': 'md5=a44f72c72b873d0f8f3021690bb3e52f',
    'rpm': 'salt://rpmforge/files/rpmforge-release-0.5.2-2.el4.rf.x86_64.rpm',
  } %}
{% elif grains['osmajorrelease'][0] == '5' %}
  {% set pkg = {
    'key': 'salt://rpmforge/files/RPM-GPG-KEY.dag.txt',
    'key_hash': 'md5=a44f72c72b873d0f8f3021690bb3e52f',
    'rpm': 'salt://rpmforge/files/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm',
  } %}
{% elif grains['osmajorrelease'][0] == '6' %}
  {% set pkg = {
    'key': 'salt://rpmforge/files/RPM-GPG-KEY.dag.txt',
    'key_hash': 'md5=a44f72c72b873d0f8f3021690bb3e52f',
    'rpm': 'salt://rpmforge/files/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm',
  } %}
{% elif grains['osmajorrelease'][0] == '7' %}
  {% set pkg = {
    'key': 'salt://rpmforge/files/RPM-GPG-KEY.dag.txt',
    'key_hash': 'md5=a44f72c72b873d0f8f3021690bb3e52f',
    'rpm': 'salt://rpmforge/files/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm',
  } %}
{% endif %}

install_pubkey_rpmforge:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag
    - source: {{ pkg.key }}
    - source_hash: {{ pkg.key_hash }}

rpmforge_release:
  pkg.installed:
    - sources:
      - rpmforge-release: {{ pkg.rpm }}
    - require:
      - file: install_pubkey_rpmforge

set_pubkey_rpmforge:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/rpmforge.repo
    - pattern: '^gpgkey = .*'
    - repl: 'gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag'
    - require:
      - pkg: rpmforge_release

set_gpg_rpmforge:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/rpmforge.repo
    - pattern: 'gpgcheck = .*'
    - repl: 'gpgcheck = 1'
    - require:
      - pkg: rpmforge_release

{% if salt['pillar.get']('rpmforge:disabled', False) %}
disable_rpmforge:
  file.replace:
    - name: /etc/yum.repos.d/rpmforge.repo
    - pattern: '^enabled = [0,1]'
    - repl: 'enabled = 0'
{% else %}
enable_rpmforge:
  file.replace:
    - name: /etc/yum.repos.d/rpmforge.repo
    - pattern: '^enabled = [0,1]'
    - repl: 'enabled = 1'
{% endif %}

{% endif %}
