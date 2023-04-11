#!/bin/bash
# Used by Update Notifier module inside puppet
checkupdates | awk 'END{print NR}'
