#!/usr/bin/env bash
# Converteer een markdown-concept naar een Word-document met HAN-stijl.
#
# Gebruik:
#   ./convert-to-docx.sh <markdown-input> [output-docx]
#
# Als output-docx niet wordt opgegeven, wordt het opgeslagen naast de
# markdown-bron met dezelfde naam, eindigend op .docx.
#
# Vereiste tools:
#   * pandoc (brew install pandoc)
#
# Vereiste bestanden:
#   * han-rapport-template.docx in dezelfde map als dit script

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/han-rapport-template.docx"

# Argumenten
if [ $# -lt 1 ]; then
    echo "Gebruik: $0 <markdown-input> [output-docx]"
    exit 1
fi

INPUT="$1"
if [ ! -f "$INPUT" ]; then
    echo "Foutmelding: invoerbestand niet gevonden: $INPUT"
    exit 1
fi

# Output-pad bepalen
if [ $# -ge 2 ]; then
    OUTPUT="$2"
else
    OUTPUT="${INPUT%.md}.docx"
fi

# Pandoc-check
if ! command -v pandoc >/dev/null 2>&1; then
    echo "Foutmelding: pandoc is niet geïnstalleerd."
    echo "Installeer pandoc met: brew install pandoc"
    exit 2
fi

# Template-check
if [ ! -f "$TEMPLATE" ]; then
    echo "Waarschuwing: HAN-rapport-template niet gevonden op $TEMPLATE."
    echo "Conversie gaat door met pandoc-standaardstijlen."
    echo ""
    echo "Voor HAN-stijlen: kopieer een eerder ingeleverd .docx-rapport naar"
    echo "  $TEMPLATE"
    echo "Pandoc neemt dan font, marges, koppen-stijlen en paginaopmaak over."
    echo ""
    pandoc "$INPUT" -o "$OUTPUT"
else
    pandoc "$INPUT" --reference-doc="$TEMPLATE" -o "$OUTPUT"
fi

echo "Geschreven: $OUTPUT"
