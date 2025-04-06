# Implementing a Layered Security Approach with Intrusion Detection Systems (IDS)

## Project Overview

This project demonstrates the implementation of a layered security approach using Docker containers and Suricata as an Intrusion Detection System (IDS). The environment consists of segmented network zones, firewall controls, and comprehensive monitoring to detect and prevent various cyber attacks.

## Architecture

Our architecture implements defense-in-depth through three distinct security zones:

1. **External Zone** - Connected to the Internet (untrusted network)
2. **DMZ Zone** - Hosting public-facing services (web server, mail server, DNS)
3. **Internal Network** - Containing sensitive systems (database, application servers)

Each zone is protected by dedicated firewalls, and all traffic is monitored by Suricata IDS.

## Components

### Network Infrastructure
- Docker networks for segmentation (external_net and internal_net)
- Alpine-based firewall containers with iptables rules
- Traffic routing controls between zones

### Security Monitoring
- **Suricata IDS**: Monitors traffic in all network segments
- **Custom Detection Rules**: Configured for various attack types
- **ELK Stack**: For log collection, analysis and visualization

### Services
- Web Server (Nginx)
- Mail Server 
- Database Server (MariaDB)
- DNS Server
- Client workstation

## Attack Detection Capabilities

Our IDS implementation detects multiple attack vectors:

1. **Reconnaissance**: Port scanning and network mapping
2. **Web Attacks**: SQL injection, XSS, path traversal
3. **Brute Force Attacks**: Authentication attack attempts
4. **Denial of Service**: SYN floods and other DoS patterns
5. **Data Exfiltration**: Suspicious outbound data transfers

## Demonstration

The project includes scripts to generate both normal and malicious traffic patterns to demonstrate the effectiveness of our security controls:

- Normal traffic simulation (HTTP requests, DNS queries)
- Port scanning detection
- SQL injection attempts
- Cross-site scripting (XSS) attacks
- Brute force login attempts
- Denial of Service (DoS) simulation

## Implementation Technologies

- Docker and Docker Compose for containerization
- Suricata for intrusion detection
- Alpine Linux for lightweight containers
- Nginx for web services
- MariaDB for database services
- ELK Stack (Elasticsearch, Logstash, Kibana) for log management

## Key Findings

Our implementation demonstrated several important security principles:

1. **Defense in Depth** provides comprehensive protection against various attack types
2. **Visibility** through IDS monitoring is essential for threat detection
3. **Rule Tuning** is critical to balance detection capabilities with false positives
4. **Security Integration** between different components enhances overall protection

## Setup Instructions

### Prerequisites
- Docker and Docker Compose installed
- At least 8GB RAM and 50GB free disk space
- Basic understanding of networking concepts

### Deployment
1. Clone this repository
2. Run `docker-compose up -d` to deploy all containers
3. Execute traffic generation scripts for testing
4. View alerts in Suricata logs or Kibana dashboard

## Demonstration Commands

### 1. Checking Environment Status
```bash
# View all running containers
docker ps

# View network configuration
docker network ls
docker network inspect security_lab_new_external_net
docker network inspect security_lab_new_internal_net
```

### 2. Examining Suricata Configuration
```bash
# Check Suricata rules
docker exec -it suricata sh -c "ls -la /etc/suricata/rules/"

# View rule content
docker exec -it suricata sh -c "cat /etc/suricata/rules/local.rules"
docker exec -it suricata sh -c "cat /etc/suricata/rules/port-scan.rules"

# Check if Suricata is running correctly
docker exec -it suricata sh -c "ps aux | grep suricata"

# Validate Suricata configuration
docker exec -it suricata sh -c "suricata -c /etc/suricata/suricata.yaml -T"
```

### 3. Network Connectivity Tests
```bash
# Test basic connectivity
docker exec -it traffic_generator ping -c 3 webserver
docker exec -it traffic_generator curl -s http://webserver/

# Test connectivity to internal network
docker exec -it traffic_generator ping -c 3 database
```

### 4. Attack Simulation
```bash
# Run comprehensive traffic generation
docker exec -it traffic_generator sh /scripts/generate_traffic.sh

# Specific attack simulations:

# Port scan attack
docker exec -it traffic_generator nmap -sS webserver

# SQL injection attack
docker exec -it traffic_generator curl "http://webserver/search?query=1%27%20union%20select%20*%20from%20users--"

# XSS attack
docker exec -it traffic_generator curl "http://webserver/page?data=<script>alert(1)</script>"

# Path traversal attack
docker exec -it traffic_generator curl "http://webserver/include?file=../../../etc/passwd"

# Brute force login
docker exec -it traffic_generator sh -c "for i in {1..10}; do echo \"Login attempt $i\"; curl -s -X POST http://webserver/login -d \"username=admin&password=test$i\"; done"

# DoS simulation (light version)
docker exec -it traffic_generator sh -c "for i in {1..50}; do curl -s http://webserver/ > /dev/null & sleep 0.1; done"
```

### 5. Monitoring for Alerts
```bash
# Check alert logs
docker exec -it suricata sh -c "cat /var/log/suricata/fast.log"

# Check JSON alert details
docker exec -it suricata sh -c "grep -A 10 'alert' /var/log/suricata/eve.json"

# Monitor logs in real-time
docker exec -it suricata sh -c "tail -f /var/log/suricata/fast.log"

# List all log files
docker exec -it suricata sh -c "ls -la /var/log/suricata/"
```

### 6. Firewall Configuration
```bash
# View external firewall rules
docker exec -it external_firewall sh -c "iptables -L -n -v"

# View internal firewall rules
docker exec -it internal_firewall sh -c "iptables -L -n -v"

# Add port scanning protection to external firewall
docker exec -it external_firewall sh -c "iptables -A FORWARD -p tcp -m recent --name portscan --seconds 60 --hitcount 20 -j DROP"

# Add SYN flood protection
docker exec -it external_firewall sh -c "iptables -A FORWARD -p tcp --syn -m limit --limit 1/s --limit-burst 3 -j ACCEPT && iptables -A FORWARD -p tcp --syn -j DROP"

# Protect internal network
docker exec -it internal_firewall sh -c "iptables -A FORWARD -i eth0 -o eth1 -p tcp --dport 3306 -s 172.18.0.3 -j ACCEPT && iptables -A FORWARD -i eth0 -o eth1 -j DROP"
```

### 7. Kibana Dashboard (If Accessible)
```bash
# Check if Kibana is running
curl -I http://localhost:5601

# Access in browser: http://localhost:5601
```

### 8. Rule Tuning Demonstration
```bash
# Modify rule threshold to reduce false positives
docker exec -it suricata sh -c "sed -i 's/count 20, seconds 60/count 50, seconds 60/' /etc/suricata/rules/port-scan.rules"

# Restart Suricata to apply changes
docker exec -it suricata sh -c "kill -USR2 \$(pidof suricata) || docker restart suricata"

# Verify the changed rule
docker exec -it suricata sh -c "grep count /etc/suricata/rules/port-scan.rules"
```

### 9. Web Server Configuration
```bash
# View web server configuration
docker exec -it webserver sh -c "cat /etc/nginx/conf.d/default.conf"

# Add security headers (simulated change)
docker exec -it webserver sh -c "echo 'add_header X-XSS-Protection \"1; mode=block\";' > /tmp/headers.conf"
```

