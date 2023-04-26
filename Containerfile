ARG FEDORA_MAJOR_VERSION=38
ARG BASE_CONTAINER_URL=quay.io/fedora-ostree-desktops/sericea

FROM ${BASE_CONTAINER_URL}:${FEDORA_MAJOR_VERSION}
ARG RECIPE

# copy over configuration files
COPY etc /etc
# COPY usr /usr

# copy scripts
RUN mkdir /tmp/scripts
COPY scripts /tmp/scripts
RUN find /tmp/scripts -type f -exec chmod +x {} \;
# RUN rpm-ostree override remove firefox firefox-langpacks foot rofi &&

COPY ${RECIPE} /tmp/ublue-recipe.yml

# yq used in build.sh and the setup-flatpaks recipe to read the recipe.yml
# copied from the official container image as it's not avaible as an rpm
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

# copy and run the build script
COPY build.sh /tmp/build.sh
RUN chmod +x /tmp/build.sh && /tmp/build.sh

# clean up and finalize container build
RUN rm -rf \
        /tmp/* \
        /var/* && \
    ostree container commit
