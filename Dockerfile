FROM debian:bookworm-slim

ARG BINARY

RUN apt update && apt install -y sqlite3 watch && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash corrosion

COPY entrypoint.sh /entrypoint.sh
COPY $BINARY /usr/local/bin/corrosion

ENTRYPOINT ["/entrypoint.sh"]

CMD ["corrosion", "agent"]
