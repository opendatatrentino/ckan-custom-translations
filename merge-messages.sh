#!/bin/bash

## Wrapper around msgcat

OUTPUT_FILE="$1"
if [ ! -e "$OUTPUT_FILE" ]; then
    shift
fi
SOURCE_FILES="$@"

echo "Input: $SOURCE_FILES"
echo "Output: $OUTPUT_FILE"
mkdir -p "$( dirname "$OUTPUT_FILE" )"
msgcat --use-first $SOURCE_FILES > "$OUTPUT_FILE"
