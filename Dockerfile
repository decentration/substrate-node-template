# This is the build stage for substrate. Here we create the binary in a temporary image.
FROM decentration/supersig-node-template:v0.1.0 as builder

WORKDIR /substrate

RUN cargo build --locked --release

# This is the 2nd stage: a very small image where we copy the substrate binary."
FROM docker.io/library/ubuntu:20.04
LABEL description="Multistage Docker image for substrate: a platform for web3" \
	io.parity.image.type="builder" \
	io.parity.image.authors="chevdor@gmail.com, devops-team@parity.io, ramsey@decentration.org" \
	io.parity.image.vendor="Decentration working with Parity Technologes substrate framework" \
	io.parity.image.description="substrate: a framework for web3" \
	io.parity.image.source="https://github.com/paritytech/substrate/blob/${VCS_REF}/scripts/ci/dockerfiles/substrate/substrate_builder.Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/substrate/"

COPY --from=builder /substrate/target/release/node-template /usr/local/bin

RUN useradd -m -u 1000 -U -s /bin/sh -d /substrate substrate && \
	mkdir -p /data /substrate/.local/share && \
	chown -R substrate:substrate /data && \
	ln -s /data /substrate/.local/share/substrate && \
# unclutter and minimize the attack surface
	rm -rf /usr/bin /usr/sbin && \
# check if executable works in this container
	/usr/local/bin/node-template --version

USER substrate

EXPOSE 30333 9933 9944 9615
VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/substrate"]