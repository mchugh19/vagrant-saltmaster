#!/usr/bin/python

import salt.client

client = salt.client.LocalClient()
returns = client.cmd_batch('*', 'cmd.run', ['uptime'], batch='1', bwait=5, batch_wait=5)
for ret in returns:
    print(ret)
