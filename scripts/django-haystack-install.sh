#!/bin/bash
set -e
if [[ "$VIRTUAL_ENV" == "" ]]
then
    echo "This Script must be run from within a virtualenv";
    exit 1;
fi

if [ ! -d "$VIRTUAL_ENV/src/django-haystack" ] 
then
    git clone https://github.com/toastdriven/django-haystack.git $VIRTUAL_ENV/src/django-haystack
    cd $VIRTUAL_ENV/src/django-haystack && pip install -e .
fi
