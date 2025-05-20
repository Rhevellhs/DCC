# Stage 1: Build
FROM alpine:latest AS builder


RUN apk add --no-cache g++ musl-dev
WORKDIR /app


COPY main.cpp .


RUN g++ -static -o hello main.cpp


FROM scratch
COPY --from=builder /app/hello /hello


CMD ["/hello"]
