#!/bin/bash

pkgs=(
    "git"
    "unzip"
    "tar"
    "findutils"
    "https://github.com/PowerShell/PowerShell/releases/download/v7.5.0/powershell-7.5.0-1.rh.x86_64.rpm"
    "wget"
    "procps-ng"
    "dnf-plugins-core"
)

[[  $(command -v dnf) ]] && dnf install --quiet --assumeyes "${pkgs[@]}"

dnf config-manager --add-repo "https://mise.jdx.dev/rpm/mise.repo"
dnf install --quiet --assumeyes mise

# mise requires gpg-agent
# Amazon Linux 2023 comes with gnupg2-minimal which does not include gpg-agent
# below command swaps out -minimal for the full gnupg2 package that includes gpg-agent
dnf swap gnupg2-minimal.x86_64 gnupg2.x86_64