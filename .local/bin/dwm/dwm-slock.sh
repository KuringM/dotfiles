#!/usr/bin/env bash

slock -m "$(cowsay "$(fortune)" | lolcat -ft)"
