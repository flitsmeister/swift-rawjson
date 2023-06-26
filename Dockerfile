FROM swift:latest as builder
WORKDIR /root

COPY Package.* .

RUN swift package resolve

COPY Sources Sources
COPY Tests Tests

RUN swift build -v
RUN swift test -v
RUN swift package clean
RUN swift build -v -c release --product RawJson

FROM swift:slim
WORKDIR /root

COPY --from=builder /root/.build/release/libRawJson.a /root/libRawJson.a

