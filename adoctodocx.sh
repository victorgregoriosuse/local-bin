#!/bin/bash

#
# SLE 15 Requirements: ruby2.5-rubygem-asciidoctor, pandoc
#
# Reference
# https://rmoff.net/2020/04/16/converting-from-asciidoc-to-google-docs-and-ms-word/
#

INPUT_ADOC=${1:?}

asciidoctor --backend docbook --out-file - $INPUT_ADOC| \
pandoc --from docbook --to docx --output $INPUT_ADOC.docx
exit $?
