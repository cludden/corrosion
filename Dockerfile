FROM --platform=$BUILDPLATFORM debian:bookworm-slim as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM

COPY dist/corrosion_aarch64-unknown-linux-gnu/corrosion /usr/local/bin/corrosion-arm64
COPY dist/corrosion_x86_64-unknown-linux-gnu/corrosion /usr/local/bin/corrosion-amd64

RUN if [ "$BUILDPLATFORM" = "linux/amd64" ]; then \
        cp /usr/local/bin/corrosion-amd64 /usr/local/bin/corrosion; \
    elif [ "$BUILDPLATFORM" = "linux/arm64" ]; then \
        cp /usr/local/bin/corrosion-arm64 /usr/local/bin/corrosion; \
    fi


FROM --platform=$BUILDPLATFORM debian:bookworm-slim

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN apt update && apt install -y sqlite3 watch && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash corrosion

COPY entrypoint.sh /entrypoint.sh

COPY --from=builder /usr/local/bin/corrosion /usr/local/bin/

ENTRYPOINT ["/entrypoint.sh"]

CMD ["corrosion", "agent"]
