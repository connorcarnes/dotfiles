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

dnf config-manager addrepo --from-repofile=https://mise.jdx.dev/rpm/mise.repo
dnf install --quiet --assumeyes mise

# if ! mise="$(command -v mise)"; then
# 	echo "Installing mise" >&2
#     curl https://mise.run | bash
# fi

files=$(find "$CONTAINER_WORKSPACE_FOLDER" -type f)

TF_VERSION="1.6.2"
TF_URL="https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
[[  $(printf '%s\n' $files | grep '\.tf$') ]] \
    && curl --silent --location --remote-name "${TF_URL}" \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_${TF_VERSION}_linux_amd64.zip

# curl --silent --output "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
#     && unzip awscliv2.zip \
#     && ./aws/install \
#     && rm -rf awscliv2.zip aws \
#     && echo "complete -C '/usr/local/bin/aws_completer' aws" >> ~/.bashrc

# Install shfmt
# https://github.com/mvdan/sh/releases/latest/download/shfmt_v3.9.0_linux_amd64
# SHFMT_VERSION=3.9.0
# curl --silent --location --remote-name "https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_linux_amd64" \
#     && chmod +x "shfmt_v${SHFMT_VERSION}_linux_amd64" \
#     && mv "shfmt_v${SHFMT_VERSION}_linux_amd64" /usr/local/bin/shfmt

# # https://github.com/ankitpokhrel/jira-cli
# JIRA_CLI_VERSION=1.5.2
# curl --silent --location --remote-name "https://github.com/ankitpokhrel/jira-cli/releases/download/v${JIRA_CLI_VERSION}/jira_${JIRA_CLI_VERSION}_linux_x86_64.tar.gz" \
#     && tar --extract --gzip --file  "jira_${JIRA_CLI_VERSION}_linux_x86_64.tar.gz" \
#     && mv jira_${JIRA_CLI_VERSION}_linux_x86_64/bin/jira /usr/local/bin/jira \
#     && chmod +x /usr/local/bin/jira \
#     && rm "jira_${JIRA_CLI_VERSION}_linux_x86_64.tar.gz"

# # https://gitlab.com/gitlab-org/cli
# GLAB_CLI_VERSION=1.49.0
# curl --silent --location --remote-name "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_CLI_VERSION}/downloads/glab_${GLAB_CLI_VERSION}_linux_amd64.tar.gz" \
#     && tar --extract --gzip --file  "glab_${GLAB_CLI_VERSION}_linux_amd64.tar.gz" \
#     && mv bin/glab /usr/local/bin/glab \
#     && chmod +x /usr/local/bin/glab \
#     && rm "glab_${GLAB_CLI_VERSION}_linux_amd64.tar.gz" \
#     && glab completion -s bash > /etc/bash_completion.d/glab

# git clone --recursive https://github.com/reconquest/shdoc
# cd shdoc
# sudo make install

# wget --quiet --output-document=- "https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz" | tar --extract --xz --verbose \
#     && mv "shellcheck-stable/shellcheck" /usr/local/bin/
