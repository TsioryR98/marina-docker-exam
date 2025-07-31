FROM ocaml/opam:debian-ocaml-5.2

USER root

RUN apt-get update && \
    apt-get install -y make --no-install-recommends build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user for running the application for default linux user
#RUN usermod -u $1000 opam && \
#    groupmod -g 1000 opam && \
 #   mkdir -p /out && \
  #  chown -R opam:opam /out

USER opam

WORKDIR /app
# guarantee that the opam user has the necessary permissions
COPY --chown=opam:opam . . 

RUN opam init --disable-sandboxing --auto-setup && \
    opam install ocamlfind ounit2 && \
    eval $(opam env) && \
    make depend && \
    make  

RUN cp /app/marina /out/marina && chmod 755 /out/marina

