#!/bin/sh

guix environment --ad-hoc curl zip unzip -- curl -s "https://get.sdkman.io" | bash
