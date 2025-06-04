FROM rust:1.78 as builder
WORKDIR /src
COPY . .
RUN cargo build --release
FROM debian:bookworm-slim
WORKDIR /app
COPY --from=builder /src/target/release/app .
EXPOSE 8080
CMD ["./app"]