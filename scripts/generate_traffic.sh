#!/bin/sh
echo "Generating network traffic for IDS testing..."

# Basic connectivity test
echo "Testing basic connectivity..."
ping -c 5 webserver

# Web server access
echo "Accessing web server..."
curl -s http://webserver/ > /dev/null

# Port scan simulation
echo "Simulating port scan..."
nmap -sS webserver

# SQL injection attempt
echo "Simulating SQL injection attempt..."
curl -s "http://webserver/search?query=1%27%20union%20select%20*%20from%20users--" > /dev/null

# XSS attempt
echo "Simulating XSS attempt..."
curl -s "http://webserver/page?data=<script>alert(1)</script>" > /dev/null

# Path traversal attempt
echo "Simulating path traversal..."
curl -s "http://webserver/include?file=../../../etc/passwd" > /dev/null

# Brute force login attempt
echo "Simulating brute force login attempt..."
for i in $(seq 1 10); do
  echo "Login attempt $i"
  curl -s -X POST http://webserver/login -d "username=admin&password=test$i" > /dev/null
  sleep 0.5
done

# DoS simulation (light version - don't want to actually DoS the server)
echo "Simulating DoS attack (light version)..."
for i in $(seq 1 50); do
  curl -s http://webserver/ > /dev/null &
  sleep 0.1
done

echo "Traffic generation complete!"
