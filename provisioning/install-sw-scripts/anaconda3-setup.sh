# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2016: Oliver Schulz.


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/bin/conda"
}


pkg_install() {
    DOWNLOAD_URL="https://repo.continuum.io/archive/Anaconda3-${PACKAGE_VERSION}-Linux-x86_64.sh"
    echo "INFO: Download URL: \"${DOWNLOAD_URL}\"." >&2

    download "${DOWNLOAD_URL}" > anaconda-installer.sh
    bash ./anaconda-installer.sh -b -p "${INSTALL_PREFIX}"

    conda clean -y --tarballs

    mkdir "${INSTALL_PREFIX}/devbin"
    mv "${INSTALL_PREFIX}/bin"/*-config "${INSTALL_PREFIX}/devbin"

    # Install mamba via micromamba since conda solver takes ages or fails to do it:
    wget -qO- https://anaconda.org/conda-forge/micromamba/0.17.0/download/linux-64/micromamba-0.17.0-0.tar.bz2 | tar -xvj bin/micromamba
    bin/micromamba -r "${INSTALL_PREFIX}" install -y mamba -n base -c conda-forge
}


pkg_env_vars() {
cat <<-EOF
PATH="${INSTALL_PREFIX}/bin:\$PATH"
MANPATH="${INSTALL_PREFIX}/share/man:\$MANPATH"
EOF
}
