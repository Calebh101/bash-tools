#!/bin/bash

target="$1"
pathinput="${2/#\~/$HOME}"
project_dir="$(realpath "${pathinput-"$(pwd)"}")"
publish="$project_dir/publish"
dir="$project_dir/publish/$target"
cd "$project_dir"

if [ -z "$1" ]; then
    echo "Usage: cscompile <target: win-x64, linux-x64, osx-x64, osx-arm64, win-arm64> <project dir: optional>"
    exit 1
fi

if [ ! -f *.csproj ]; then
    echo "Error: C# project not found at directory $project_dir"
    exit 1
fi

echo -e "Starting publish for target $target\nProject dir:\t$project_dir\nOutput dir:\t$dir\nContinue?"
read

if [ ! -d "$publish" ]; then
  mkdir "$publish"
fi

if [ -d "$dir" ]; then
    rm -rf "$dir"
fi

mkdir "$dir"
dotnet publish -c Release -r $target --self-contained true -p:PublishSingleFile=true -o "$dir" -p:DebugType=None -p:DebugSymbols=false
echo "Result published in $dir"