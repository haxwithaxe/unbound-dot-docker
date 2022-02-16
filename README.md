# Description
This image just acts as a DoT (DNS over TLS) forwarding resolver without any extra configuration. It is intended to be used with Pi-Hole.

# Build
`docker-compose build` or docker-compose build --build-arg provider=<provider> --build-arg stack=<stack>`. The default provider is `cloudflare` and the default stack is `ipv4`.

## Stacks
***Currently only the `ipv4` stack has been tested***, but there are configs for `ipv6` and `dualstack` as well.

## Providers
***Currently only the IPv4 versions of the providers have been tested***. The available providers are `cloudflare`, `quad9`, or `google`.

## Important build actions
Building this image does some things that break idempotence. The following actions may make the image different from build to build.
* Updates the CA certs.
* Updates the root server hints.

## Important actions not taken durring the build
The root server DNSSEC keys are added but not updated. They will automatically update when Unbound starts/restarts anyways, but it's good to have them from the start.

# Config
There is no need to edit the config files to make this image work (at least for `ipv4` right now). If you want to add additional configs you can add them to a volume and mount it under `/etc/unbound/unbound.conf.d/` with `.conf` extentions.
