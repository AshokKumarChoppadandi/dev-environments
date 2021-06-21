#!/bin/bash

usage() { echo "Usage: $0 [-n <45|90>] [-p <string>]" 1>&2; exit 1; }

while getopts ":n:p:" o; do
    case "${o}" in
        n)
            n=${OPTARG}
            ((n == 45 || n == 90)) || usage
            ;;
        p)
            p=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${n}" ] || [ -z "${p}" ]; then
    usage
fi

echo "n = ${n}"
echo "p = ${p}"