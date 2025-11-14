#!/bin/bash
#
# This requires an environment varaibale called BLITZMAX to be set up to point to your
# working BlitzMax root folder. Do not include a trailing slash.
#
# export BLITZMAX=~/BlitzMax
#
echo
echo PACKRAT.MOD SETUP
echo ======================================================================

if [[ ! -v BLITZMAX ]]; then
    echo "!! BLITZMAX environment variable is not set"
    exit 1
fi

if [ ! -f $BLITZMAX/bin/bmk ]; then
    echo "!! Cannot find $BLITZMAX/bin/bmk"
    exit 1
fi

# CLEANUP

echo "- Removing obsolete files"

find . -name "*.a" -type f -delete
find . -name "*.i" -type f -delete
find . -name "*.o" -type f -delete
find . -name "*.s" -type f -delete

# COMPILE

echo "- Compiling..."

$BLITZMAX/bin/bmk makemods -a packrat.visitor
$BLITZMAX/bin/bmk makemods -a packrat.patterns

# EOF
