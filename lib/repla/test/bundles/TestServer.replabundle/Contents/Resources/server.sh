#!/usr/bin/env bash

set -e

cd ../../../../html/
ruby -run -e httpd -- -p 5000 .

