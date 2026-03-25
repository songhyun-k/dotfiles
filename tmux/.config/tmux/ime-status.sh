#!/bin/sh
src=$(command -v im-select >/dev/null 2>&1 && im-select || echo "")
case "$src" in
  *Korean*)  echo "한" ;;
  *ABC*)     echo "EN" ;;
  *Japanese*) echo "あ" ;;
  "")        echo "" ;;
  *)         echo "${src##*.}" ;;
esac
