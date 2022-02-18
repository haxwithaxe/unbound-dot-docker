#!/bin/bash

set -e

VERSION=${VERSION:-$1}

if [[ -z "$VERSION" ]]; then
	echo '$VERSION or an argument must be specified.'
	exit 1
fi

# Clear out and setup the push script
echo -e "#!/bin/bash\nset -e" > $(dirname $0)/push.sh

add_to_push() {
	echo "docker push $1" >> $(dirname $0)/push.sh
}

buid_provider() {
	local provider=$1
	local version=$2
	local stack="ipv4"  # Only building ipv4 images for now
	# Build provider latest (equivalent to <version>-<provider>-ipv4)
	docker build --build-arg provider=$provider --build-arg stack=ipv4 --tag haxwithaxe/unbound-dot:latest-${provider} .
	add_to_push haxwithaxe/unbound-dot:latest-${provider}
	# Build provider for this version (equivalent to <version>-<provider>-ipv4)
	docker build --build-arg provider=$provider --build-arg stack=ipv4 --tag haxwithaxe/unbound-dot:${version}-${provider} .
	add_to_push haxwithaxe/unbound-dot:${version}-${provider}
	# Build provider images with specific tags
	docker build --build-arg provider=$provider --build-arg stack=$stack --tag haxwithaxe/unbound-dot:latest-${provider}-${stack} .
	add_to_push haxwithaxe/unbound-dot:latest-${provider}-${stack}
	docker build --build-arg provider=$provider --build-arg stack=$stack --tag haxwithaxe/unbound-dot:${version}-${provider}-${stack} .
	add_to_push haxwithaxe/unbound-dot:${version}-${provider}-${stack}
}

# Build all tags but latest and $VERSION
for provider in "cloudflare" "google" "quad9"; do
	buid_provider $provider $VERSION
done

# Build $VERSION
docker build --build-arg provider=cloudflare --build-arg stack=ipv4 --tag haxwithaxe/unbound-dot:${VERSION} .
add_to_push haxwithaxe/unbound-dot:${VERSION}
# Build latest
docker build --build-arg provider=cloudflare --build-arg stack=ipv4 --tag haxwithaxe/unbound-dot:latest .
add_to_push haxwithaxe/unbound-dot:latest
