FROM ubuntu:24.04 AS godot-base
ARG VERSION="4.5.1"
ARG DOTNET_VERSION="8.0"

# Install dependencies
# - ca-certificates for wget
# - xz-utils for extracting tar.xz
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    git-lfs \
    unzip \
    wget \ 
    xz-utils \
    dotnet-sdk-${DOTNET_VERSION} \
    ca-certificates \
    && update-ca-certificates

ENV GODOT_VERSION=$VERSION
ENV GODOT_HOME="/usr/local/bin"
ENV GODOT_FILENAME="Godot_v${GODOT_VERSION}-stable_mono_linux"
ENV GODOT_PATH="${GODOT_HOME}/${GODOT_FILENAME}_x86_64"
ENV GODOT_BIN="${GODOT_PATH}/godot"

RUN mkdir -p ${GODOT_HOME} & echo "Godot version is: ${GODOT_VERSION}"

# Download and install Godot
# sample URL: https://github.com/godotengine/godot/releases/download/4.5.1-stable/Godot_v4.5.1-stable_mono_linux_x86_64.zip
RUN wget -q https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/${GODOT_FILENAME}_x86_64.zip -P /tmp \
    && unzip -q /tmp/${GODOT_FILENAME}_x86_64.zip -d ${GODOT_HOME} \
    && mv ${GODOT_HOME}/${GODOT_FILENAME}_x86_64/${GODOT_FILENAME}.x86_64 ${GODOT_BIN} \
    && chmod u+x ${GODOT_BIN} \
    && rm /tmp/${GODOT_FILENAME}_x86_64.zip

# Add to path
ENV PATH="${GODOT_PATH}:${PATH}"
RUN echo ${PATH}

# Run Godot at least once
RUN godot -v -e --quit --headless

FROM godot-base AS godot-blender
ARG VERSION="4.5.1"
ARG BLENDER_VERSION="4.5.5"

# Download and install Blender (latest from APT)
# numpy required for exporting
RUN apt-get update && apt-get install -y --no-install-recommends \
    blender \
    python3-numpy

# Install display drivers? (Blender)
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     libx11-dev \
#     libxcursor-dev \
#     libxinerama-dev \
#     libxrandr-dev \
#     libxi-dev \
#     libglu1-mesa-dev \
#     && rm -rf /var/lib/apt/lists/*

# Download and install Blender
# sample URL: https://download.blender.org/release/Blender4.5/blender-4.5.5-linux-x64.tar.xz
# RUN BLENDER_MAJOR_MINOR="${BLENDER_VERSION%.*}" \
#     && echo "Blender major-minor version: $BLENDER_MAJOR_MINOR" \
#     && wget https://download.blender.org/release/Blender$BLENDER_MAJOR_MINOR/blender-${BLENDER_VERSION}-linux-x64.tar.xz -P /tmp \
#     && tar -xf /tmp/blender-${BLENDER_VERSION}-linux-x64.tar.xz -C /usr/local/bin \
#     && rm /tmp/blender-${BLENDER_VERSION}-linux-x64.tar.xz

# Set blender path in godot editor settings
# filesystem/import/blender/blender_path = ""
RUN GODOT_MAJOR_MINOR="${VERSION%.*}" && \
    echo "Godot major-minor version: $GODOT_MAJOR_MINOR" && \
    GODOT_EDITOR_SETTINGS="/root/.config/godot/editor_settings-${GODOT_MAJOR_MINOR}.tres" && \
    #BLENDER_PATH="/usr/local/bin/blender-${BLENDER_VERSION}-linux-x64/blender"
    BLENDER_PATH="/usr/bin/blender" && \
    sed -i  "/^filesystem\/import\/blender\/blender_path = \"\"$/c\filesystem/import/blender/blender_path = \"$BLENDER_PATH\"" $GODOT_EDITOR_SETTINGS

FROM godot-blender AS godot-export

# Get Godot export templates.
RUN wget -q https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_mono_export_templates.tpz \
    && mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono \
    && ln -s ~/.local/share/godot/templates ~/.local/share/godot/export_templates \
    && unzip -q Godot_v${GODOT_VERSION}-stable_mono_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono \
    && rm -f Godot_v${GODOT_VERSION}-stable_mono_export_templates.tpz