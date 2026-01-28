# Miniflux Infrastructure

This directory contains the Miniflux RSS reader stack, managed by `docker-compose` and started automatically via `nix-darwin`.

## Components
- **Miniflux**: RSS reader (port 8080)
- **PostgreSQL 16**: Database
- **Caddy**: Reverse proxy for `http://miniflux.local` (port 80)

## Setup & Management

### 1. Apply Nix Configuration
The stack is wired into `darwin-configuration.nix`. To apply changes:
```bash
darwin-rebuild switch --flake .#darwin-system
```

### 2. Verify Status
Check if the containers are running:
```bash
cd services/miniflux
docker compose ps
```

### 3. Access
- **URL**: [http://miniflux.local](http://miniflux.local)
- **iPad/Local Network Access**: `http://192.168.15.13:8080` (Mac must be on the same Wi-Fi)
- **Default Admin**: `admin` / `change-me-now`
- *Note: Change the password immediately after first login.*

## Troubleshooting
- **Logs**: `docker compose logs -f`
- **Launchd Logs**:
  - Out: `~/Library/Logs/miniflux.out.log`
  - Err: `~/Library/Logs/miniflux.err.log`
- **Manual Start**: `docker compose up -d` in this directory.
