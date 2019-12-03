/dev/sdb:
  lvm.pv_present

storage_vg:
  lvm.vg_present:
    - devices: /dev/sdb
    - require: 
      - lvm: /dev/sdb

srv_lv:
  lvm.lv_present:
    - name: srv
    - vgname: storage_vg
    - extents: 100%FREE
    - require: 
      - lvm: storage_vg

/dev/mapper/storage_vg-srv:
  blockdev.formatted: 
    - fs_type: xfs
    - require: 
      - lvm: srv_lv

srv_mount:
  mount.mounted:
    - name: /srv
    - device: /dev/mapper/storage_vg-srv
    - fstype: xfs
    - persist: True
    - require: 
      - blockdev: /dev/mapper/storage_vg-srv
