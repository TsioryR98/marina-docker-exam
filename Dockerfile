FROM ocaml/opam:debian-ocaml-5.2 AS builder

USER root
RUN apt-get update && \
    apt-get install -y make build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /out && chown opam:opam /out

USER opam
WORKDIR /app

COPY --chown=opam:opam . .

RUN opam init --disable-sandboxing --auto-setup && \
    opam install ocamlfind ounit2 && \
    eval $(opam env) && \
    make depend && make


# Image Flask + binary marina
FROM python:3.12-slim

WORKDIR /app

COPY server/ /app/
RUN pip install flask

# /app/bin 
RUN mkdir -p /app/bin

COPY --from=builder /app/marina /app/bin/marina
RUN chmod 755 /app/bin/marina

EXPOSE 5000

#copy marina binary from app/bin/marina to out/marina
CMD ["sh", "-c", "cp /app/bin/marina /out/marina && python server.py"]
