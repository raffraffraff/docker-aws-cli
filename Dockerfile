FROM python:3.8-alpine as builder

ENV AWS_CLI_VERSION 2.0.24

RUN apk add git groff less
RUN pip3 install --ignore-installed --target /opt/aws-cli git+git://github.com/aws/aws-cli.git#${AWS_CLI_VERSION}

# NOTE: This will not persist in the final image, but will persist in a cached image on the build host
COPY awscreds/* /root/.aws/

COPY files/* /tmp/
COPY scripts/* /usr/bin/

RUN /usr/bin/find_aws_command_dependencies
RUN /usr/bin/remove_aws_cli_components


FROM alpine:latest

ENV PATH=${PATH}:/opt/aws-cli/bin
ENV PYTHONPATH=/opt/aws-cli

RUN apk add python3 groff
RUN ln -s  /usr/bin/python3 /usr/local/bin/python

COPY --from=builder /opt/aws-cli /opt/aws-cli

ENTRYPOINT ["aws"]
CMD ["-c","aws"]
