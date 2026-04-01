**Custom Caddy build with deSEC DNS & CrowdSec Bouncer**

This image provides an automated, production-ready build of Caddy v2. It includes pre-installed plugins for **DNS-01 challenges via deSEC** and **Layer 7 intrusion prevention via CrowdSec**. 

### Key Features
* **Automatic Updates:** Rebuilds daily to ensure the base image and plugins are always at the latest version.
* **Security Hardened:** Includes the **caddy-crowdsec-bouncer** to block malicious actors at the edge.
* **Wildcard SSL:** Includes **caddy-dns/desec** for automated HTTPS certificates without opening port 80.
* **Multi-Registry:** Available on both Docker Hub and GitHub Container Registry (GHCR).

---

### Quick Start
```bash
docker run -d \
  --name crowdesec-caddy \
  -p 80:80 \
  -p 443:443 \
  -e DESEC_TOKEN="your_token" \
  -v $PWD/Caddyfile:/etc/caddy/Caddyfile \
  -v caddy_data:/data \
  -v caddy_config:/config \
  dragonrider01598/crowdesec-caddy:latest
```

---

### Supported Tags
* `latest`: The most recent stable build (recommended).
* `sha-<git-ref>`: Specific builds tied to the GitHub commit for version pinning.

---

### Configuration

#### 1. CrowdSec Bouncer Setup
To enable the IPS/Bouncer, add the global options to the top of your **Caddyfile**:

```caddy
{
    crowdsec {
        api_url http://crowdsec:8080
        api_key {$CROWDSEC_LAPI_KEY}
        ticker_interval 60s
    }
}
```

#### 2. deSEC DNS-01 Setup (Wildcard SSL)
Use this inside your site block to handle certificates via DNS (perfect for internal services):

```caddy
*.example.com {
    tls {
        dns desec {$DESEC_TOKEN}
    }
    reverse_proxy localhost:8080
}
```

---

### Using with Docker Compose
```yaml
services:
  caddy:
    image: dragonrider01598/crowdesec-caddy:latest
    container_name: crowdesec-caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    environment:
      - DESEC_TOKEN=your_desec_token
      - CROWDSEC_LAPI_KEY=your_bouncer_key
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
      - caddy_config:/config

volumes:
  caddy_data:
  caddy_config:
```

---

### Resources
* [GitHub Repository](https://github.com/DragonRider01598/crowdesec-caddy)
* [Caddy-CrowdSec-Bouncer Documentation](https://github.com/hslatman/caddy-crowdsec-bouncer)
* [deSEC DNS Plugin Documentation](https://github.com/caddy-dns/desec)
* [Official Caddy Documentation](https://caddyserver.com/docs/)
