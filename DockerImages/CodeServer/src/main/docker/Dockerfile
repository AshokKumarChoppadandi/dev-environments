FROM quay.io/centos/centos:stream9

LABEL author="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" \
        maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" \
        description="VS Code running CentOS 9 Stream"

USER root

WORKDIR /

COPY config.yaml /
COPY code-server-entrypoint.sh /

RUN dnf update -y \
    && dnf install java-1.8.0-openjdk-devel wget ncurses unzip nc net-tools -y \
    && curl -fsSL https://code-server.dev/install.sh | sh \
    && chmod +x /code-server-entrypoint.sh

ENV DEFAULT_LOGIN_PASSWORD NoPass@123
ENV HOST 0.0.0.0
ENV PORT 8080

ENTRYPOINT ["./code-server-entrypoint.sh"]

CMD ["sh"]
