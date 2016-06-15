#!/bin/env ruby
# Script for checking broadband usage and remaning data for BSNL
# Vijay Soni (vs4vijay@gmail.com)

require 'open-uri'

BSNL_USAGE_URL = "http://172.30.35.27/bsnlfup/usage.php"

response = open(BSNL_USAGE_URL).read

remaining_data = response[/<td>(.* GB)/]

puts "Remaining Data : #{remaining_data}"
