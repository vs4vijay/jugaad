#!/bin/env ruby
# Script for checking broadband usage and remaning data for BSNL
# Vijay Soni (vs4vijay@gmail.com)
require 'open-uri'

BSNL_USAGE_URL = "http://172.30.35.27/bsnlfup/usage.php"
puts "[+] Getting Data from Server"
response = open(BSNL_USAGE_URL).read
remaining_data = response[/<td>(.* GB)/]

puts "[+] Remaining Data : #{remaining_data}"
puts "=================="
puts "Last Usage Details: \n#{DATA.read}"

`echo "#{Time.now} - #{remaining_data}" >> #{__FILE__}`

__END__
2016-06-15 23:59:52 +0530 - <td>1999.447 GB
2016-06-15 23:59:54 +0530 - <td>1999.447 GB
2016-06-15 23:59:56 +0530 - <td>1999.447 GB
2016-06-15 23:59:58 +0530 - <td>1999.447 GB
