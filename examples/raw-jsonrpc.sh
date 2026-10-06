#!/usr/bin/env bash
# Raw MCP calls against the wptaskify server. You need an OAuth access token
# (any MCP client gets one for you; see https://wptaskify.com/developers#authentication).
set -euo pipefail
MCP="https://wptaskify.com/mcp"
: "${ACCESS_TOKEN:?set ACCESS_TOKEN first}"

# 1. initialize - keep the Mcp-Session-Id response header
SESSION=$(curl -s -D - -o /dev/null -X POST "$MCP" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"example","version":"1.0"}}}' \
  | awk -F': ' 'tolower($1)=="mcp-session-id"{print $2}' | tr -d '\r')

# 2. tools/list
curl -s -X POST "$MCP" \
  -H "Authorization: Bearer $ACCESS_TOKEN" -H "Mcp-Session-Id: $SESSION" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'

# 3. tools/call - list the sites on this account
curl -s -X POST "$MCP" \
  -H "Authorization: Bearer $ACCESS_TOKEN" -H "Mcp-Session-Id: $SESSION" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"list_my_sites","arguments":{}}}'
