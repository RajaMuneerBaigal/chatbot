FROM rust:1.67 as builder
WORKDIR /chatbot
COPY ./ ./
RUN cargo install  --path .

FROM debian:buster-slim
RUN apt-get update && apt-get install -y libssl1.1
COPY --from=builder /chatbot/target/release/liveu_stats_bot .

# set the startup command to run your binary
CMD ["./liveu_stats_bot"]
