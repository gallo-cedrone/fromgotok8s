FROM golang:1.13 as builder
WORKDIR /go/src/github.com/gallo-cedrone/fromgotok8s
COPY . .
RUN make compile

FROM busybox
COPY --from=builder /go/src/github.com/gallo-cedrone/fromgotok8s/bin /
