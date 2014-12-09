#!/bin/bash
make clobber
./auto-build.sh klte rel
make clobber
./auto-build.sh kltespr rel
make clobber
./auto-build.sh klteusc rel
make clobber
./auto-build.sh kltedv rel
