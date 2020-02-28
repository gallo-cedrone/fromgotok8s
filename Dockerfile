FROM golang:1.13 as builder
ARG CGO_ENABLED=0
WORKDIR /go/src/github.com/gallo-cedrone/fromgotok8s
COPY . .
RUN make compile

FROM scratch
COPY --from=builder /go/src/github.com/gallo-cedrone/fromgotok8s/bin/fromgotok8s /fromgotok8s
