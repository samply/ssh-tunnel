# Bridgehead SSH Tunnel

Bridgehead SSH Tunnel is a Dockerized SSH tunnel that exposes configurable ports. This tool is designed to be used in the [Bridgehead](https://github.com/samply/bridgehead) to connect to remote machines running factored out components of the Bridgehead.

## Prerequisites

* Docker (version 20.10+)
* Docker Compose (version 1.27+)

## Usage

### Configuration

**Configuration File:** The configuration file (`/etc/bridgehead/ssh-tunnel.conf`) defines the tunnels you want to expose. The file must be mounted to /ssh-tunnel.conf in the container as read-only.

The configuration file consists of one tunnel per line written in the format `<Listening-Address>:<LHS-Port>:<Host-interface-adress>:<Host-port>`. 
The `Listening-Address` should most likely **not** be localhost but `::0`, `0.0.0.0`, `*`, or a specific interface.


Example configuration (`/etc/bridgehead/ssh-tunnel.conf`):

```
*:9001:localhost:9001
0.0.0.0:8080:localhost:8080
```

**Environment Variables:** The container expects the environment variables `SSH_TUNNEL_USERNAME` for the login-user and `SSH_TUNNEL_HOST` for the remote machine hostname/IP address.

**Private Key:** The private key for authentication must be available as a Docker Compose secret. This key must not be protected by a passphrase, as the container cannot handle interactive prompts.
Store your private key in a Docker secret called `privkey`. Ensure it's accessible and properly secured (e.g., with permissions `600`).

### Docker Compose Setup

Thi container is designed to be used in a Bridgehead module, however, you can use it standalone as well (e.g. for testing). Create a docker-compose.yml file in your project directory with the following content:

```
version: "3.7"

services:
  ssh-tunnel:
    image: samply/ssh-tunnel:latest
    container_name: bridgehead-ccp-ssh-tunnel
    environment:
      SSH_TUNNEL_USERNAME: "${SSH_TUNNEL_USERNAME}"
      SSH_TUNNEL_HOST: "${SSH_TUNNEL_HOST}"
    volumes:
      - "/etc/bridgehead/ssh-tunnel.conf:/ssh-tunnel.conf:ro"
    secrets:
      - privkey
secrets:
  privkey:
    file: /etc/bridgehead/ssh-tunnel.priv.pem
```

Note, that this `docker-compose.yml` does not expose any ports; the forwarded port is only accessible from within this docker network. Add your application to the docker compose stack or expose the ports manually.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
