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