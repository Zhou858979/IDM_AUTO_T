# IDM自动温补程序
## 下载与安装
```
cd ~
git clone https://github.com/Zhou858979/IDM_AUTO_T.git
cd IDM_AUTO_T
./install.sh
```
## 配置文件
```
[gcode_macro DATA_SAMPLE]
gcode:
  {% set bed_temp = params.BED_TEMP|default(90)|int %}
  {% set nozzle_temp = params.NOZZLE_TEMP|default(250)|int %}
  {% set min_temp = params.MIN_TEMP|default(50)|int %}
  {% set max_temp = params.MAX_TEMP|default(60)|int %}
  M106 S255
  _IDM_WAIT_COIL_TEMP MAXIMUM={min_temp}
  M106 S0
  G28
  G0 Z1
  M104 S{nozzle_temp}
  M140 S{bed_temp}
  _IDM_WAIT_COIL_TEMP MINIMUM={min_temp}
  IDM_STREAM FILENAME=data1
  _IDM_WAIT_COIL_TEMP MINIMUM={max_temp}
  IDM_STREAM FILENAME=data1
  M104 S0
  M140 S0
  M106 S255
  G0 Z80
  _IDM_WAIT_COIL_TEMP MAXIMUM={min_temp}
  M106 S0
  G28 Z0
  G0 Z2
  M104 S{nozzle_temp}
  M140 S{bed_temp}
  G4 P1000
  IDM_STREAM FILENAME=data2
  _IDM_WAIT_COIL_TEMP MINIMUM={max_temp}
  IDM_STREAM FILENAME=data2
  M104 S0
  M140 S0
  M106 S255
  G0 Z80
  _IDM_WAIT_COIL_TEMP MAXIMUM={min_temp}
  M106 S0
  G28 Z0
  G0 Z3
  M104 S{nozzle_temp}
  M140 S{bed_temp}
  G4 P1000
  IDM_STREAM FILENAME=data3
  _IDM_WAIT_COIL_TEMP MINIMUM={max_temp}
  IDM_STREAM FILENAME=data3
  M104 S0
  M140 S0
  _IDM_TEMP_COMPENSATE_APPLY
```