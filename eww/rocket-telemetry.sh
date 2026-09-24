#!/bin/bash
while true; do
  # CPU Temperature (ДВИГАТЕЛЬ)
  CPU_TEMP=$(sensors | grep -E 'Tctl|CPU|Package' | head -n 1 | awk '{print $2}' | tr -d '+°C' | cut -d. -f1)
  [ -z "$CPU_TEMP" ] && CPU_TEMP="--"

  # GPU Temperature (РЕАКТОР) - checks nvidia-smi or sensors
  GPU_TEMP=""
  if command -v nvidia-smi &>/dev/null; then
    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader 2>/dev/null)
  fi
  if [ -z "$GPU_TEMP" ]; then
    GPU_TEMP=$(sensors | grep -iE 'edge|junction|amdgpu' | head -n 1 | awk '{print $2}' | tr -d '+°C' | cut -d. -f1)
  fi
  [ -z "$GPU_TEMP" ] && GPU_TEMP="--"

  # Fan Speed (РАДИАТОРЫ)
  FAN_RPM=$(asusctl fan-curve -g 2>/dev/null | grep -i 'speed' | head -n 1 | tr -cd '0-9')
  if [ -z "$FAN_RPM" ]; then
    FAN_RPM=$(sensors | grep -i 'fan1' | awk '{print $2}' | tr -cd '0-9')
  fi
  [ -z "$FAN_RPM" ] && FAN_RPM="0"

  # Formatted compactly to fit your 235px layout
  echo "ДВИГ: ${CPU_TEMP}°C | РЕАКТ: ${GPU_TEMP}°C | РАД: ${FAN_RPM}"
  sleep 3
done
