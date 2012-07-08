#!/bin/sh

cabal list --simple-output --installed | awk '{print $1}' | uniq | xargs -I {} cabal install {} --reinstall
