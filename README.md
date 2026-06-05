# Kali Linux Docker with XRDP

Kali Linux container with XFCE desktop accessible via RDP (Remote Desktop Protocol).

## Prerequisites

- Docker & Docker Compose
- RDP client (Microsoft Remote Desktop, Remmina, or built-in Windows RDP)
- OpenVPN (for TryHackMe - install on **host machine**, not in container)

## Setup

1. **Configure credentials:**
   ```bash
   cp .env.example .env
   # Edit .env to set your RDP username/password
   ```

2. **Build and start container:**
   ```bash
   docker compose build
   docker compose up -d
   ```

3. **Check logs:**
   ```bash
   docker compose logs -f
   ```

## Connect via RDP

- **Host:** `localhost`
- **Port:** `3390`
- **Username:** (from .env, default: `kali`)
- **Password:** (from .env, default: `kali`)

### Connection Examples

**macOS (Microsoft Remote Desktop):**
- Add PC: `localhost:3390`
- Enter credentials when prompted

**Linux (Remmina):**
```bash
remmina -c rdp://kali@localhost:3390
```

**Windows:**
```
mstsc /v:localhost:3390
```

## TryHackMe VPN Setup

**Keep OpenVPN on your host machine** (recommended approach):

1. **Download your TryHackMe .ovpn file**
2. **Connect on host:**
   ```bash
   sudo openvpn ~/Downloads/yourfile.ovpn
   ```
3. **Container automatically uses host's VPN connection**

### Why host-side VPN?
- ✅ No container networking complexity
- ✅ No credential management in container
- ✅ Easy connect/disconnect without rebuilding
- ✅ Container traffic automatically routed through VPN

### Alternative: Host Network Mode
If you need container to fully share host network:
```bash
# Uncomment network_mode in docker-compose.yml
network_mode: "host"
```
Then connect via `localhost:3390` (xrdp still on port 3390)

## Useful Commands

```bash
# Start container
docker compose up -d

# Stop container
docker compose down

# Rebuild after Dockerfile changes
docker compose build --no-cache

# Shell access
docker exec -it kali-xrdp bash

# View logs
docker compose logs -f
```

## Installing Additional Tools

Inside the container or via RDP terminal:
```bash
sudo apt update
sudo apt install -y kali-tools-top10  # Popular tools
sudo apt install -y metasploit-framework nmap wireshark
```

## Troubleshooting

**Can't connect via RDP:**
- Check container is running: `docker ps`
- Check logs: `docker compose logs`
- Verify port 3390 not in use: `lsof -i :3390`

**VPN not working:**
- Ensure OpenVPN running on host: `ifconfig` (look for tun0)
- Test from container: `docker exec -it kali-xrdp ping <tryhackme-ip>`

**Slow performance:**
- Increase Docker resources (CPU/RAM) in Docker Desktop settings
- Consider using lighter desktop: `apt install kali-desktop-lxde`
