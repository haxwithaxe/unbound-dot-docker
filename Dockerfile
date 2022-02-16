FROM debian:bullseye-slim

# Select the DOT provider.
# Options are "cloudflare", "quad9", or "google".
ARG provider=cloudflare
# Select the network stack type of the config.
# Options are "ipv4", "ipv6", or "dualstack".
ARG stack=ipv4

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
    	unbound \
        wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Update the CA certs.
RUN update-ca-certificates

# Update the root server hints.
RUN wget https://www.internic.net/domain/named.root -O /etc/unbound/root.hints

# Clear out any extra unbound configs.
RUN rm /etc/unbound/unbound.conf.d/*

# Add the spcified unbound config file.
COPY --chown=unbound:unbound  stacks/${stack}.conf /etc/unbound/unbound.conf
COPY --chown=unbound:unbound  providers/${provider}/${stack}.conf /etc/unbound/provider.conf

# Bootstrap the root server DNSSEC keys. They will automatically update when 
#  Unbound starts/restarts.
COPY --chown=unbound:unbound  initial-root.key /etc/unbound/root.key

RUN chown -R unbound /etc/unbound && chmod o+rwX /etc/unbound

EXPOSE 53/tcp
EXPOSE 53/udp

ENTRYPOINT ["unbound"]
