#!/usr/bin/env bash

SSH_AUTH_SOCK_PATH=~/.ssh/ssh-agent.sock
if [ -e "$SSH_AUTH_SOCK_PATH" ]; then rm $SSH_AUTH_SOCK_PATH; fi
