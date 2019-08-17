shared_user:
  group.present:
    - name: tea
    - gid: 6666
  user.present:
    - name: tea
    - uid: 6666
    - gid: 6666
    - shell: /bin/zsh
    - enforce_password: true
    - password: '!!'
    - require: 
      - group: shared_user

shared_user_keys:
  ssh_auth.present:
    - user: tea
    - names: 
      - 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKv4Ewwyr8377S9oGPr6ZclHBt6afmqH32LuBFyi8/XR Shared_key_generated_on_Moria'
      - 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEr3cezNLi6e9WdQhjBmvPd/zliWMZfBkE1lMVIyWy/o key_generated_for_roaming_access_on_Sat,_Oct__1,_2016_12:07:41_PM'
    - require: 
      - user: shared_user

shared_user_sudo:
  file.managed:
    - name: /etc/sudoers.d/tea
    - contents: |
        tea ALL=(ALL) NOPASSWD: ALL
