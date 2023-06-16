ARG FEDORA_MAJOR_VERSION=38
ARG BASE_IMAGE_URL=quay.io/fedora-ostree-desktops/sericea

FROM ${BASE_IMAGE_URL}:${FEDORA_MAJOR_VERSION}

# copy over configuration files
COPY /config/sway/config /etc/sway/
COPY /config/51-android.rules /etc/udev/rules.d
ARG RECIPE=./recipe.yml

# Copy the recipe that we're building.
COPY ${RECIPE} /usr/share/ublue-os/recipe.yml

# "yq" used in build.sh and the "setup-flatpaks" just-action to read recipe.yml.
# Copied from the official container image since it's not available as an RPM.
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

# Copy the build script and all custom scripts.
COPY scripts /tmp/scripts

# Run the build script, then clean up temp files and finalize container build.
RUN chmod +x /tmp/scripts/build.sh && \
        /tmp/scripts/build.sh && \
        rm -rf /tmp/* /var/* && \
        ostree container commit
