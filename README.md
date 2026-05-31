# Open Journal Systems (OJS) - Docker Development Environment

This repository contains a Docker-based development environment for Open Journal Systems (OJS).

For the official OJS documentation, please visit:
[https://github.com/pkp/ojs](https://github.com/pkp/ojs)

## How to use with Docker

### Prerequisites
- Docker
- Docker Compose

### Getting Started

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone --recursive https://github.com/darius-v/OJS.git
   cd ojs
   ```

2. **Start the environment**:
   Run the following command from the root of the project:
   ```bash
   docker compose -f docker/docker-compose.yml up --build
   ```

3. **Access the application**:
   - **OJS**: [http://localhost:8080](http://localhost:8080)
   - **phpMyAdmin**: [http://localhost:8081](http://localhost:8081)

### Notes
- The first build may take some time as it installs PHP extensions, Composer dependencies, and NPM packages.
- The `config.inc.php` will be automatically generated from the template if it doesn't exist.
- Database credentials (configured in `docker-compose.yml`):
    - **Host**: `mysql`
    - **Database**: `ojs`
    - **Username**: `ojs`
    - **Password**: `ojs`
    - **Root Password**: `root`
