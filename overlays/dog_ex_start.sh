#!/bin/bash
export HOME=/opt/dog_ex
export HOSTKEY=$(sha1sum /var/consul/data/pki/certs/server.crt | cut -d' ' -f1)

/opt/dog_ex/bin/dog start
