FROM ocaml/opam:debian-ocaml-5.2

USER root

RUN apt-get update && \
    apt-get install -y make --no-install-recommends build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /out && chown opam:opam /out

USER opam

WORKDIR /app

COPY --chown=opam:opam . .

RUN opam init --disable-sandboxing --auto-setup && \
    opam install ocamlfind ounit2 && \
    eval $(opam env) && \
    make depend && make
