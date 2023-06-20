FROM swift:latest as builder
WORKDIR /root

COPY Package.* .

RUN sed -i.bu 's/^[^#]*.plugin(/\/\/&/' Package.swift; \
    sed -i.bu 's/^[^#]*realm\/SwiftLint/\/\/&/' Package.swift; \
    sed -i.bu 's/^[^#]*nicklockwood\/SwiftFormat/\/\/&/' Package.swift

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

