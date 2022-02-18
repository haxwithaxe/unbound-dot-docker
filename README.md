# Description
This set of images each act as a DoT (DNS over TLS) forwarding resolver without any extra configuration. It is intended to be used with Pi-Hole.

# Composition
This set of images is intended to be used in composition with Pi-Hole. See [this](https://github.com/haxwithaxe/pi-hole-docker) implementation for details.

# Run
To run it on its own `docker run -p 53:53 -p 53:53/udp haxwithaxe/unbound-dot:latest`. Then point your DNS client at it and enjoy. For example run `dig @127.0.0.1 one.one.one.one` on the host machine.

# Tags
Tags take the form of <version>-<provider>-<stack>. If the stack is omitted then the stack is `ipv4`. If the provider is omitted then the provider is `cloudflare`. For now only `ipv4` images will be published on [Docker Hub](https://hub.docker.com/r/haxwithaxe/unbound-dot).
* `latest`, `0.1`, `latest-cloudflare`, `0.1-cloudflare`, `0.1-cloudflare-ipv4` are the same.
* `latest-google`, `0.1-google`, `0.1-google-ipv4` are the same.
* `latest-quad9`, `0.1-quad9`, `0.1-quad9-ipv4` are the same.

# Build
`docker build .` or `docker build --build-arg provider=<provider> --build-arg stack=<stack> .`. The default provider is `cloudflare` and the default stack is `ipv4`.

## Stacks
***Currently only the `ipv4` stack has been tested***, but there are configs for `ipv6` and `dualstack` as well.

## Providers
***Currently only the IPv4 versions of the providers have been tested***. The available providers are `cloudflare`, `quad9`, or `google`.

## Important build actions
Building this image does some things that break idempotence. The following actions may make the image different from build to build.
* Updates the CA certs.
* Updates the root server hints.

## Important actions not taken during the build
The root server DNSSEC keys are added but not updated. They will automatically update when Unbound starts/restarts anyways, but it's good to have them from the start.

# Config
There is no need to edit the config files to make this image work (at least for `ipv4` right now). If you want to add additional configs you can add them to a volume and mount it under `/etc/unbound/unbound.conf.d/` with `.conf` extensions.
