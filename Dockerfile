FROM golang:alpine AS builder

WORKDIR /build
RUN apk --no-cache add git && git clone https://github.com/Idix/alertmanager-webhook-signald .
RUN go mod tidy && CGO_ENABLED=0 go build

FROM alpine:3.13

COPY --from=builder "/build/alertmanager-webhook-signald" "/build/alerts.tmpl" /app/

USER 1001:1001
EXPOSE 9716
ENTRYPOINT ["/app/alertmanager-webhook-signald"]
CMD ["--config", "/app/config.yaml"]
