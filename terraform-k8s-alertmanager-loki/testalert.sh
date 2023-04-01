#! /usr/bin/env sh

URL="http://localhost:9093/api/v1/alerts"

curl -si -X POST -H "Content-Type: application/json" "$URL" -d '
[
  {
    "labels": {
      "alertname": "InstanceDown10",
      "instance": "localhost:8080",
      "job": "node",
      "severity": "critical"
    },
    "annotations": {
      "summary": "Instance is down10"
    },
    "generatorURL": "http://localhost:9090/graph"
  }
]
'
