# DOCKER-VERSION 1.5.0
#
# # Camlistore Docker
#
FROM centos:centos7
MAINTAINER Lee Olayvar <leeolayvar@gmail.com>


# Env
ENV USER root
ENV HOME /data
ENV GOPATH /go
ENV GOBIN /go/bin
ENV GOROOT /usr/local/go
ENV PATH $PATH:$GOBIN:/usr/local/go/bin


# ## Install runtime dependencies
# (no runtime deps at this time)
RUN yum update -y \

# ## Install build dependencies
# (to be removed at the end of this run statement)
  && yum install -y \
    tar git \

# ## Install Golang
  && cd /tmp \
  && curl -O "https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz" \
  && tar -xzf go1.4.2.linux-amd64.tar.gz \
  && mv go /usr/local/go \

# ## Install Camlistore
  && cd /tmp \
  && git clone https://camlistore.googlesource.com/camlistore \
  && cd camlistore \
  && git checkout 2d1241b \
  && go run make.go \
  && mv ./bin/* /bin \

# ## Cleanup
  && cd / \
  && rm -rf /tmp && mkdir /tmp \
  && yum remove -y \
    tar git \
  && yum clean all


# Config
EXPOSE 80

# Storage
VOLUME ["/data"]

# Run
CMD ["camlistored", "-listen", ":80"]
