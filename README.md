# Arlen Developer Website

Production website and self-hosted reference project for the Arlen GNUstep/Cocoa MVC framework.

## Project Goals

1. Operate as the public-facing Arlen website.
2. Run the site entirely on Arlen controllers, routes, and templates.
3. Host Arlen documentation sourced from the Arlen repository.

## Structure

- `vendor/Arlen`: Arlen framework submodule (source of docs + runtime CLI).
- `src/main.m`: route registration and server startup.
- `src/Controllers/HomeController.m`: landing/docs/guides/showcase/install pages.
- `templates/`: EOC templates, layout, and shared nav partial.
- `public/`: CSS, JS, logo assets, and generated docs output.

## Local Development

```bash
source /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
git submodule update --init --recursive
./vendor/Arlen/bin/arlen boomhauer --port 3015
```

Open `http://127.0.0.1:3015/`.

## Sync Arlen Docs

```bash
./scripts/sync-arlen-docs.sh
```

Then open `http://127.0.0.1:3015/docs/latest`.

## Key Routes

- `/` landing page
- `/docs` docs hub
- `/docs/latest` redirects to generated docs HTML
- `/guides/get-started` quickstart guide
- `/examples` showcase page
- `/download` install instructions
- `/dogfood` JSON endpoint proving the site runs on Arlen
- `/healthz` health check

## User-Level systemd Service (port 3015)

The user service file is managed at:

- `~/.config/systemd/user/arlen-website.service`

Install or refresh it from this repo:

```bash
./scripts/install-user-service.sh
```

Manual controls:

```bash
systemctl --user daemon-reload
systemctl --user enable --now arlen-website.service
systemctl --user status arlen-website.service
```
