#!/usr/bin/env bash

set -euo pipefail

cat - | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
