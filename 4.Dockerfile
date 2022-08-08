# This is the build stage for substrate. Here we create the binary in a temporary image.
FROM docker.io/ubuntu:20.04 as builder

WORKDIR /substrate
COPY . /substrate

RUN apt-get install sudo
RUN sudo apt install build-essential
RUN clang curl git make
RUN sudo apt install --assume-yes git clang curl libssl-dev
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
RUN source $HOME/.cargo/env
RUN rustup default stable
RUN rustup update
RUN rustup update nightly
RUN rustup target add wasm32-unknown-unknown --toolchain nightly



