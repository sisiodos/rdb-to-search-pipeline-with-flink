#!/bin/bash

osq() {
  local index="${1:-_all}"
  local size="${2:-10}"

  curl -s -X GET "http://localhost:9200/${index}/_search?pretty" \
    -H 'Content-Type: application/json' \
    -d "{
      \"query\": { \"match_all\": {} },
      \"size\": ${size}
    }"
}
