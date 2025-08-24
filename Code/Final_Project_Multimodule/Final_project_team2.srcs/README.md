# Final UART-Controled Sensor & Watch / Stopwatch System on FPGA 
## 📝 Overview
본 프로젝트는 **Basys-3 기반 SW 및 Buttonㅇ으로 디지털 시계 및 스톱워치 기능을 제어**하는 FPGA 시스템입니다.
명령은 버튼 및 스위치를 통해 안정적으로 처리되며, Verilog로 구현된 여러 모듈들이 유기적으로 동작하여 시계 모드와 스톱워치 모드를 전환 및 제어합니다.

## 🎯 Features
- **Watch & Stopwatch 기능 통합**
- **디지털 디스플레이(FND) 출력**

## 🛠️ Architecture
- `fnd_controller.v`: Basys-3의 Display 출력을 위한 모듈
- `btn_debounce.v`: shift Register 동작을 이용해 버튼 입력 시 발생하는 채터링을 제거
- `realwatch`: 실제 디지털 시계처럼 동작하며, 시, 분, 초를 조작 가능한 모듈(Control unit 및 Data Path로 나누어짐)
- `stopwatch`: stopwatch 기능을 구현(Control unit 및 Data Path로 나누어짐)

## 🖼️ Block Diagram
```
[ PC Terminal ]
      |
      v
[ btn_debounce ] --> [ Control Unit ] --> [ Data Path ] --> [ top watch(stopwatch.v) ] --> [ 7-Segment Display ]
```

## 🧪 Simulation
Vivado 시뮬레이션을 통해 각 명령에 대한 동작을 검증하였습니다.
