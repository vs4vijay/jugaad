#!/usr/bin/env bash


ETH_XPS="http://customer.expl.in"
LOGIN_URL="${ETH_XPS}/Customer/LoginCENTER.aspx?h8=1"
DASHBOARD_URL="${ETH_XPS}/Customer/Gauge.aspx"

USERNAME="${1}"
PASSWORD="${USERNAME}"

COOKIE_FILE="${USERNAME}-ETH-XPS-Cookies.txt"

echo -n "\[31m[+] Logging in to Account(${USERNAME}) to Domain(${ETH_XPS})\n"

curl -c ${COOKIE_FILE} -L ${LOGIN_URL} \
	-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:64.0) Gecko/20100101 Firefox/64.0' \
	-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
	-H 'Accept-Language: en-US,en;q=0.5' \
	-H "Referer: ${LOGIN_URL}" \
	-H 'Content-Type: application/x-www-form-urlencoded' \
	-H 'Connection: keep-alive' \
	-H 'Upgrade-Insecure-Requests: 1' \
    --data '__VIEWSTATE=%2FwEPDwUJNTU1MzUxMjQxD2QWAgIDD2QWBAIGDw8WAh4EVGV4dAXxAUg4IFNlcnZpY2UsIFN1YnNjcmliZXIgJiBSZXZlbnVlIE1hbmFnZW1lbnQgU3lzdGVtIGlzIG9uZSBvZiB0aGUgYmVzdCBzb2x1dGlvbnMgZm9yIFRlbGVjb20gSW5kdXN0cmllcyBhY3Jvc3MgdGhlIGdsb2JlLiBJbXByb3ZlIFByb2R1Y3Rpdml0eSwgRWZmaWNpZW50IFByb2Nlc3NlcywgT3JnYW5pemVkIEJ1c2luZXNzICYgSW5jcmVhc2UgUHJvZml0YWJpbGl0eSBpcyB0aGUgZXh0cmVtZSBmb2N1cyBvZiBIOCBTU1JNUy5kZAIJDw8WAh8ABa0BU2VydmljZSwgU3Vic2NyaWJlciAmIFJldmVudWUgTWFuYWdlbWVudCBTeXN0ZW0gKFNTUk1TKSBpcyBhIHdpZGVseSBpbXBsZW1lbnRlZCBzdHJhdGVneSBmb3IgbWFuYWdpbmcgYSBjb21wYW554oCZcyBpbnRlcmFjdGlvbnMgd2l0aCBjdXN0b21lcnMsIGNsaWVudHMgYW5kIHNhbGVzIHByb3NwZWN0cy5kZBgBBR5fX0NvbnRyb2xzUmVxdWlyZVBvc3RCYWNrS2V5X18WAQUJY2hrUmVtYmVyAzvuRTYCPhajpnj7VixfpOa5UNproJjTbh8mNzrFznM%3D'\
    --data '__VIEWSTATEGENERATOR=4B32168F&__EVENTVALIDATION=%2FwEdAA%2FI%2FwdTlBhghQ%2BIsO%2BUEAdZUHYK43IYkbUz%2FB7D6H%2Ft12N6ZYJNGAQHn0c9zMgZU3B2NvjHOkq5wKoqN6Aim8WGW9cakfYrRCgbwaj3Zkgu0Nt6hu8N8WiaDaLbH6Yz4wf7RYnhVzr6H6QcMqJmRhZm8Aci3wyluXYeKrH0qSJu2fOEhUSJ45mECvWqNggj2zGKcnEWtV2g%2Fcc26jo8DdSJ1QEsChrBxKpwe2zUuI8bHhCiZaJfcq01qqinRWGUZKTtkxsTVVObG4ztPmNqVTxxSrl%2BIylhROKxqb44UP4H6LU3zaTs9Ah%2BLyp4AX88QyHyr2L8X%2FknzUZ2EUO7HUQ19mkmcbcisiyHZlxEiNQ1rA%3D%3D'\
    --data "txtUserName=${USERNAME}&txtPassword=${PASSWORD}&save=Log+In" 2> /dev/null | grep --color -i lblNtfcMsg

echo -n "[+] Checking Usage..."

curl -b ${COOKIE_FILE} -L ${DASHBOARD_URL} 2> /dev/null | grep -e lblCurrentUsage -e spCurrentUsage | grep -o "[0-9.]*GB"