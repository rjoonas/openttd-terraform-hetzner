**This repo is no longer maintained. Check out [openttd-terraform-upcloud](https://github.com/rjoonas/openttd-terraform-upcloud) for an up-to-date dedicated server example (including annotated openttd.cfg + NewGRF extensions!) using a more reliable cloud provider.**

----

<img src="https://upload.wikimedia.org/wikipedia/commons/1/12/Achtung-orange.svg" width="32" alt="Warning" /> **WARNING:**

Please be extra careful when using Terraform with Hetzner. While developing this module I learned that recreating a server too many times a day can trigger a silent abuse ban which means they will **lock your Hetzner Cloud account without notifying you and delete all your cloud resources within 24 hours. *You will not receive any heads-up about this and there is no appeal process.*** If you want to use Hetzner regardless, your best bet is to iterate configuration on a running server instead of using configuration management tools to create it from scratch. You should still be aware that their abuse prevention algorithm can destroy your servers at any time.

----

<img src="https://raw.githubusercontent.com/OpenTTD/OpenTTD/1.9.3/media/openttd.256.png" alt="OpenTTD" width="128" align="right" />

# openttd-terraform-hetzner

***Motivation:*** *why configure local firewalls and NAT tables to host a quick game if you can just spin up a dedicated server at the push of a button?*

----

Terraform configuration to deploy an [OpenTTD](https://github.com/OpenTTD/OpenTTD) game server on European cloud provider [Hetzner Cloud](https://www.hetzner.com/cloud). The server will be running **Debian 10**, with **openttd 1.9.3** compiled from source.

With Hetzner's current rates (March 2020), you're getting a CX11 virtual server located in Finland or Germany for 0,005 € / h = 2,96 € per month.

## Deployment

Prerequisites:

* **[Hetzner Cloud](https://hetzner.cloud/) account & project API key**
  * Register at https://accounts.hetzner.com/signUp
  * In Hetzner Cloud Console, create a new project and generate an API token for it
    * *Project → Access → API Tokens → Generate API token*
* **[Terraform](https://www.terraform.io/)**
  * Can be installed eg. using Homebrew on Mac OS: `brew install terraform`
* **SSH key without a passphrase**
  * If you don't have one at hand, try something like `ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_hetzner` on a *NIX system. Leave passphrase empty so Terraform knows how to use it.

To play on a dedicated openttd server, clone the repo and:

1. Modify [openttd.cfg](openttd.cfg) with your preferred game settings
2. Run `terraform init` in the repo root directory to prepare Terraform
3. Run `terraform apply`. You're first prompted for missing config variables and then you'll get a preview of the cloud resources about to be created. Accept the execution plan by typing `yes`.
4. Wait a few minutes while Terraform creates and configures the server. Compilation is quite slow as the cheapest virtual machine only has one CPU core available.
5. Copy the server IP that Terraform prints on exit (`openttd_server_ip` in module outputs)
6. Connect OpenTTD clients by entering this IP in *Main menu → Multiplayer → Add server*

Hetzner will bill your credit card monthly (per hour) until you delete the server with `terraform destroy`.

## Manual server administration tasks

You can ssh to the server as root with the SSH key you set during provisioning. Common tasks:

* Browse openttd logs with journalctl, eg. `journalctl -o short-iso -n 500 --no-hostname --utc -u openttd`
* Configure openttd by editing `/home/openttd/.openttd/openttd.cfg`
* Restart openttd with `systemctl restart openttd`

## Configuration variables

| Variable               |  Description                                                            |
|------------------------|-------------------------------------------------------------------------|
| `hetzner_token`        | Hetzner Cloud API access token (Cloud console: *Project → API tokens*)  |
| `ssh_public_key_path`  | Path to a SSH public key that you want to use for managing the server   |
| `ssh_private_key_path` | Path to a SSH private key that you want to use for managing the server  |
| `hetzner_location`     | [Hetzner region to use](server-location) – default is Helsinki, Finland |

[server-location]: https://www.terraform.io/docs/providers/hcloud/r/server.html#location
