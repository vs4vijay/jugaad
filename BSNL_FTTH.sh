#!/usr/bin/env bash

URL="https://fuptopup.bsnl.co.in"

echo "[+] Checking Usage..."

curl -s -k "${URL}/fetchUserQuotaPM.do" \
	-H 'User-Agent: Mozilla/5.0' \
	-d location=NOID | jq
