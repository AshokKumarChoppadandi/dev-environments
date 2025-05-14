FROM quay.io/centos/centos:stream9

LABEL author="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" \
        maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" \
        description="VS Code running CentOS 9 Stream"

USER root

WORKDIR /

RUN dnf update -y \
    && dnf install java-1.8.0-openjdk-devel wget ncurses unzip nc net-tools -y \
    && curl -fsSL https://code-server.dev/install.sh | sh

ENV PASSWORD Password@123
ENV HOST 0.0.0.0
ENV PORT 8080

COPY ./config.yaml /
COPY ./code-server-entrypoint.sh /

RUN chmod +x /code-server-entrypoint.sh

ENTRYPOINT ["./code-server-entrypoint.sh"]

CMD [sh]

# CMD ["sh", "-c", "code-server --auth password --bind-addr 0.0.0.0"]


# docker build . -t ashokkumarchoppadandi/code-server:1.0 -t ashokkumarchoppadandi/code-server:latest

# docker run -idt --name custom-code-server -p 8200:8081 -e PASSWORD=Ashok@123 -e PORT=8081 ashokkumarchoppadandi/code-server:1.0

# ashokkumarchoppadandi/code-server:1.0
# docker logs -f custom-code-server

# docker rm -f custom-code-server
