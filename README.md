*This project has been created as part of the 42 curriculum by erpascua.*

# Inception

## Description
Inception is a system administration project focused on Docker and Docker Compose.
The goal is to run a small production-like stack with three isolated services:
- NGINX as the only public entrypoint on port 443 with TLS.
- WordPress with PHP-FPM.
- MariaDB as the database backend.

The stack is orchestrated with Docker Compose and persistent data is stored in host paths under /home/login/data through named volumes.

## Project Description
This project demonstrates how to package an application stack as reproducible container images.

### Why Docker in this project
- Reproducible local environments.
- Service isolation by container.
- Faster setup compared to manual package installation.
- Controlled networking between services.

### Main design choices
- Base images built from Debian.
- One Dockerfile per mandatory service.
- Dedicated startup script per service to keep container startup deterministic.
- NGINX configured for TLSv1.2/TLSv1.3 only.
- WordPress and MariaDB persisted on host storage.

### VM vs Docker
- VM virtualizes a full OS and kernel space with higher overhead.
- Docker virtualizes processes with shared host kernel and lighter resource usage
- VM is stronger for full OS isolation (necessary if docker not on same OS than host machine)
- Docker is better for fast deployment and service composition.

### Secrets vs Environment Variables
- Environment variables are easy to inject but can leak through logs, inspect output, and shell history.
- Secrets are safer for sensitive data because they can be mounted as files and managed separately.
- In this repository, .env is kept for required configuration and should contain non-sensitive placeholder values only.

### Docker Network vs Host Network
- Docker bridge networks isolate services and provide internal DNS by service name.
- Host network removes network isolation and is forbidden for this project.
- This project uses a dedicated bridge network so only NGINX is exposed publicly.

### Docker Volumes vs Bind Mounts
- Named volumes are managed by Docker and are portable and easy to inspect.
- Bind mounts point to arbitrary host paths and are more coupled to host layout.
- This project uses named volumes configured to store data under /home/login/data.

## Instructions
### Prerequisites
- Linux VM with Docker Engine and Docker Compose available.
- Domain mapping in /etc/hosts to point login.42.fr to local IP.

### Run
1. Update values in srcs/.env for your local setup.
2. Run make.
3. Open https://erpascua.42.fr.

### Useful commands
- `make up`
- `make down`
- `make clean`
- `make fclean`
- `make logs`
- `make status`

## AI Usage
AI tooling was used for:
- Reviewing shell scripts and compose consistency.
- Identifying syntax and compliance issues quickly.
- Drafting documentation structure.

All generated changes were manually reviewed, adjusted, and validated.

## Resources
- Docker
> https://docs.docker.com/
> https://docs.docker.com/compose/compose-file/
> https://www.notion.so/INCEPTION-2b50e43c57ea8038a822d04f791675f9#2eb0e43c57ea806a8f62d45c0a7d62d9
> My friend `bsuger` who perfectly explained the tricky points of inceptions
- Mariadb
> https://www.ionos.com/digitalguide/hosting/technical-matters/mariadb-docker/
> https://mariadb.com/kb/en/documentation/
- Wordpress
> https://www.hostinger.com/tutorials/run-docker-wordpress?utm_source=google&utm_medium=cpc&utm_id=22523766166&utm_campaign=Generic-Tutorials-DSA-t3|NT:Se|Lang:EN|LO:FR&utm_term=&utm_content=750581688924&gad_source=1&gad_campaignid=22523766166&gbraid=0AAAAADMy-hbdP9pvqccnFKXq0_GO5q7J_&gclid=CjwKCAjwntHPBhAaEiwA_Xp6RkvEo6rg-FqFIrs_q53QfNzZPyFpGUJmJa4oeCy8INkcrB2_IxYN1xoC4N8QAvD_BwE
> https://developer.wordpress.org/cli/commands/
- NGINX
> https://github.com/The-42-Chosen/Les-Tontons-Forkeurs-Enrolent-Fmotte/
> https://nginx.org/en/docs/http/ngx_http_ssl_module.html
