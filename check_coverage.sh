#!/bin/bash
echo "================================"
echo "COBERTURA POR ARQUIVO"
echo "================================"
bundle exec rspec --format json > /tmp/rspec.json 2>&1
cat coverage/index.html | grep -E "\.rb|coverage" | head -30
echo ""
echo "Abrindo relatório HTML..."
open coverage/index.html
