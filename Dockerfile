FROM rust:1.67 as builder
RUN cargo new --bin chatbot
WORKDIR /chatbot
COPY ./Cargo.toml ./
COPY ./Cargo.lock ./
RUN cargo build --release
RUN rm src/*.rs
ADD src ./src
RUN rm ./target/release/deps/liveu_stats_bot*
RUN cargo build --release


FROM debian:buster
RUN apt-get update 
RUN apt-get install wget -y
RUN wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.17_amd64.deb

RUN dpkg -i libssl1.1_1.1.1f-1ubuntu2.17_amd64.deb
# copy the build artifact from the build stage
RUN apt-get remove wget && apt-get autoremove
COPY --from=builder /chatbot/target/release/liveu_stats_bot .

# set the startup command to run your binary
CMD ["./liveu_stats_bot"]
