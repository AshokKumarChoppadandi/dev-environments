FROM quay.io/centos/centos:stream8

LABEL author="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" \
        maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" \
        description="CentOS 8 Stream with Jupyter Notebook for running Python, Scala & Spark Applications"

USER root

ENV CUSTOM_USER "bigdata"
ENV JUPYTER_TOKEN ""
ENV JUPYTER_PASSWORD ""
ENV JUPYTER_ALLOW_PASSWORD_RESET "False"

RUN useradd -m -s /bin/bash $CUSTOM_USER

ENV HOME_DIR /home/$CUSTOM_USER

WORKDIR $HOME_DIR

ENV JUPYTER_CONFIG_DIR $HOME_DIR/.jupyter

COPY ./jupyter_entrypoint.sh $HOME_DIR

RUN dnf makecache \
    && dnf update -y \
    && dnf install gcc python3.12-devel -y \
    && python3 -m ensurepip --upgrade \
    && chmod +x jupyter_entrypoint.sh \
    && mkdir -p $JUPYTER_CONFIG_DIR \
    && chown -R bigdata:bigdata $HOME_DIR

ENV PATH $PATH:$HOME_DIR/.local/bin
ENV JUPYTER_NOTEBOOK_PORT 8888

# COPY ./config/jupyter_notebook_config.py $HOME_DIR/.jupyter/jupyter_notebook_config.py

USER $CUSTOM_USER

RUN pip3 install --upgrade --force-reinstall --no-cache-dir jupyter --user $CUSTOM_USER

ENTRYPOINT ["./jupyter_entrypoint.sh"]
CMD ["sh"]