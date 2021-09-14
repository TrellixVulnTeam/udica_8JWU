#!/usr/bin/env bash
# prepare image to run on ecs

VERSION=${VERSION:-0.2.5}

sed -i "s/^\(version\).\+/\1 = \"${VERSION}\"/" udica/version.py

cp -v Dockerfile Dockerfile.ecs
sed -i 's#/usr/bin/udica#/usr/local/bin/udica#' Dockerfile.ecs
sed  -i "/^RUN rm -rf \/tmp\/udica\//a\\
\\
#add docker cli and jq to container\\
RUN dnf install --disableplugin=subscription-manager -y \\\ \\
      dnf-plugins-core\\
RUN dnf config-manager --add-repo \\\ \\
      https://download.docker.com/linux/fedora/docker-ce.repo\\
RUN dnf install --disableplugin=subscription-manager -y \\\ \\
      docker-ce-cli \\\ \\
      jq \\\ \\
    && rm -rf /var/cache/yum" Dockerfile.ecs

docker build -f Dockerfile.ecs -t udica:${VERSION} -t udica:latest .
