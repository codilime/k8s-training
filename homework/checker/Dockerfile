FROM bitnami/kubectl:1.15-debian-9

USER root
RUN install_packages curl jq

COPY check.sh .

ENTRYPOINT ./check.sh
