#!/usr/bin/env bash
set -euo pipefail
mvn -B clean package
java -jar target/hello-world-1.0.0.jar
