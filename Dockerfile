
# golang-s2i
FROM openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
MAINTAINER Gianni Salinetti <gbsalinetti@extraordy.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV GOPATH=/opt/app-root/go \
    GOBIN=$HOME/go/bin \
    PATH=$PATH:$GOBIN

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building Golang applications" \
      io.k8s.display-name="go 1.8" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,1.8"

EXPOSE 8080

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
RUN yum install -y golang && yum clean all -y

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN mkdir -p /opt/app-root/go/{src,pkg,bin}
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
