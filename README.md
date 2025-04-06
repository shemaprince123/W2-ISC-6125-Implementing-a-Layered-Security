# Implementing a Layered Security Approach with Intrusion Detection Systems (IDS)

## Project Overview

This project demonstrates the implementation of a layered security approach using Docker containers and Suricata as an Intrusion Detection System (IDS). The environment consists of segmented network zones, firewall controls, and comprehensive monitoring to detect and prevent various cyber attacks.

## Architecture

Our architecture implements defense-in-depth through three distinct security zones:

1. **External Zone** - Connected to the Internet (untrusted network)
2. **DMZ Zone** - Hosting public-facing services (web server, mail server, DNS)
3. **Internal Network** - Containing sensitive systems (database, application servers)

Each zone is protected by dedicated firewalls, and all traffic is monitored by Suricata IDS.

![Network Architecture Diagram](network_diagram.png)

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

## Documentation

For complete details, please refer to the comprehensive documentation PDF included in this repository, which contains:

- Detailed installation and configuration steps
- IDS rule configurations and explanations
- Traffic simulation methods
- Alert analysis procedures
- Incident investigation examples
- Preventive security measures
- Performance optimizations and rule tuning
