#!/bin/bash

# From: https://gist.github.com/n0ts/40dd9bd45578556f93e7

# You must accept the Oracle Binary Code License
# http://www.oracle.com/technetwork/java/javase/terms/license/index.html
# usage: get_jdk.sh <jdk_version> <ext>
# jdk_version: 8(default) or 9
# ext: rpm or tar.gz

jdk_version=${1:-8}
ext=${2:-rpm}

readonly url="http://www.oracle.com"
readonly jdk_download_url1="$url/technetwork/java/javase/downloads/index.html"
readonly jdk_download_url2=$(
    curl -s $jdk_download_url1 | \
    egrep -o "\/technetwork\/java/\javase\/downloads\/jdk${jdk_version}-downloads-.+?\.html" | \
    head -1 | \
    cut -d '"' -f 1
)
[[ -z "$jdk_download_url2" ]] && echo "Could not get jdk download url - $jdk_download_url1" >> /dev/stderr

readonly jdk_download_url3="${url}${jdk_download_url2}"
readonly jdk_download_url4=$(
    curl -s $jdk_download_url3 | \
    egrep -o "http\:\/\/download.oracle\.com\/otn-pub\/java\/jdk\/[8-9](u[0-9]+|\+|[.0-9]+\+).*\/jdk-${jdk_version}.*(-|_)linux-(x64|x64_bin).$ext"
)

# Fetch the newest one
jdks=($jdk_download_url4)
wget -q --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" -N ${jdks[-1]}

#for dl_url in ${jdk_download_url4[@]}; do
#    wget --no-cookies \
#         --no-check-certificate \
#         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
#         -N $dl_url
#          echo $dl_url
#done
