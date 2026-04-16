#!/usr/bin/env bash
# Check if a port is in use
# Usage: bash check_port.sh <port>
# Exit code: 0 = port is free, 1 = port is occupied

PORT="${1:?Error: port number is required}"

if lsof -i :"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  PID=$(lsof -ti :"$PORT" -sTCP:LISTEN 2>/dev/null | head -1)
  PROCESS=$(ps -p "$PID" -o comm= 2>/dev/null || echo "unknown")
  echo "⚠️  Port ${PORT} is occupied by process: ${PROCESS} (PID: ${PID})"
  exit 1
else
  echo "✅ Port ${PORT} is available"
  exit 0
fi
