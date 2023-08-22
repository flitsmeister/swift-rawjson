FROM swift:latest as package
WORKDIR /root

COPY Package.* .

RUN swift package resolve

FROM package as source
WORKDIR /root

COPY Sources Sources
COPY Tests Tests

FROM source as test
WORKDIR /root

COPY Package.* .

RUN swift package resolve

COPY Sources Sources
COPY Tests Tests

RUN swift test && touch /root/testresult.txt

FROM source as builder
WORKDIR /root

RUN swift build -c release --product RawJson

FROM swift:slim
WORKDIR /root

COPY --from=test /root/testresult.txt /root/testresult.txt
COPY --from=builder /root/.build/release /root/.build/release

