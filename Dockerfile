FROM swift:latest as test
WORKDIR /root

COPY Package.* .

RUN swift package resolve

COPY Sources Sources
COPY Tests Tests

RUN swift test & touch /root/testresult

FROM swift:latest as builder
WORKDIR /root

COPY --from=test /root/testresult /root/testresult

COPY Package.* .

RUN swift package resolve

COPY Sources Sources
COPY Tests Tests

RUN swift build -c release --product RawJson

FROM swift:slim
WORKDIR /root

COPY --from=builder /root/.build/release/libRawJson.a /root/libRawJson.a

