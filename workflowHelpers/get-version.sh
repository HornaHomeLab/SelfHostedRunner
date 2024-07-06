#!/bin/sh

grep "LABEL version=" "./Dockerfile" | awk -F= '{print $2}' | tr -d ' "'
