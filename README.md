# SIEM ELK Stack UTH

Lab project for the course **Chuyên đề – Hệ thống mạng và Bảo mật** at University of Transport Ho Chi Minh City (UTH).

The project builds a compact Security Information and Event Management (SIEM) environment on one laptop. It centralizes Windows Server event logs and pfSense firewall logs in the Elastic Stack, then uses Kibana to investigate events, visualize activity, and demonstrate rule-based alerts.

## Scope

- Elasticsearch, Logstash, and Kibana run on an Ubuntu Server virtual machine with Docker Compose.
- Windows Server sends Security, System, and Application events through Winlogbeat over TLS.
- pfSense sends firewall events as Syslog on an isolated lab network.
- Kibana provides dashboards, searches, and alert evidence for the controlled lab scenarios in the course proposal.

This is a controlled academic lab. It is not designed for Internet exposure or production use.

## Current status

Repository preparation, Ubuntu SIEM VM, dual-NIC networking, SSH connectivity, Docker Engine/Compose, and the secured Elastic Stack runtime are complete. Windows log shipper, pfSense configuration, dashboards, and alerts have not yet been deployed.

## Proposed data flow

```text
Windows Server -- Winlogbeat/TLS --> Logstash -- TLS --> Elasticsearch --> Kibana
pfSense ------- Syslog/UDP (lab) --> Logstash
```

All component versions will be pinned together. The initial planned version is Elastic Stack `9.5.6`; this is a configuration target, not evidence of a running deployment.

## Documentation

- [Architecture and proposed VMware topology](docs/01-architecture.md)
- [Implementation plan and technology decisions](docs/02-implementation-plan.md)
- [Ubuntu Server on VMware preparation guide](docs/03-setup-ubuntu-vmware.md)

## Repository layout

```text
config/       Future service, pipeline, and shipper configuration
docker/       Future Docker Compose deployment definition
docs/         Reviewed technical documentation
scripts/      Reproducible setup and controlled test scripts
screenshots/  Runtime evidence captured during testing
```

## Security rules

- Never commit `.env`, passwords, tokens, private keys, or real log exports.
- Keep Elasticsearch authentication enabled and validate TLS certificates.
- Do not expose Elasticsearch or Kibana directly to the Internet.
- Perform test activity only inside the approved VMware lab.
