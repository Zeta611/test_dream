FROM ocaml/opam:alpine as build

RUN sudo apk add --update libev-dev openssl-dev

WORKDIR /home/opam

# Install deps
ADD test_dream.opam test_dream.opam
RUN opam install . --deps-only

# Build
ADD . .
RUN opam exec -- dune build

FROM alpine:3.18.4 as run

RUN apk add --update libev

COPY --from=build /home/opam/_build/default/bin/main.exe /bin/app

ENTRYPOINT /bin/app
