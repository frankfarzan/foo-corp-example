#!/bin/bash
#
# Copyright 2018 The Nomos Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eo pipefail

# Nomosvet docker image (Docker image repo).
IMAGE=${NOMOSVET_IMAGE:-"gcr.io/nomos-release/nomosvet"}

# Nomosvet version (Docker image tag).
VERSION=${NOMOSVET_VERSION:-"stable"}

docker pull "${IMAGE}:${VERSION}" > /dev/null

if [[ -z "$1" ]] || [[ ! -d "$1" ]]; then
    docker run --rm \
      "${IMAGE}:${VERSION}" "--help"
else
    # Docker host volume bind should be an absolute path
    policy_dir="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
    shift
    docker run --rm \
      -u "$(id -u):$(id -g)" \
      -v "${policy_dir}":/policy-dir:ro \
      "${IMAGE}:${VERSION}" "$@" "/policy-dir"
fi

