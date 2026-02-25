#!/bin/bash
# Google Cloud Speech-to-Text Test Script
# Tests the same audio files used for Azure STT testing

set -e

echo "========================================================================"
echo "Google Cloud Speech-to-Text Test"
echo "========================================================================"
echo ""

# Check for gcloud CLI
if ! command -v gcloud &> /dev/null; then
    echo "❌ Error: gcloud CLI not installed"
    echo ""
    echo "Install:"
    echo "  brew install --cask google-cloud-sdk"
    echo ""
    echo "Then authenticate:"
    echo "  gcloud auth application-default login"
    exit 1
fi

# Get access token
echo "Getting access token..."
ACCESS_TOKEN=$(gcloud auth application-default print-access-token 2>/dev/null || echo "")

if [ -z "$ACCESS_TOKEN" ]; then
    echo "❌ Error: Not authenticated"
    echo ""
    echo "Run: gcloud auth application-default login"
    exit 1
fi

echo "✓ Access token obtained"
echo ""

# Function to test a file
test_file() {
    local FILE_PATH=$1
    local DESCRIPTION=$2
    local EXPECTED=$3

    echo "────────────────────────────────────────────────────────────────────────"
    echo "$DESCRIPTION"
    echo "────────────────────────────────────────────────────────────────────────"

    if [ ! -f "$FILE_PATH" ]; then
        echo "⊘ Skipped - file not found"
        echo ""
        return
    fi

    echo "  File: $FILE_PATH"
    echo "  Expected: $EXPECTED"
    echo "  Transcribing..."

    # Encode audio to base64
    AUDIO_BASE64=$(base64 -i "$FILE_PATH" | tr -d '\n')

    # Create request JSON
    REQUEST_JSON=$(cat <<EOF
{
  "config": {
    "encoding": "LINEAR16",
    "sampleRateHertz": 16000,
    "languageCode": "ar-SA",
    "enableAutomaticPunctuation": true,
    "model": "default"
  },
  "audio": {
    "content": "$AUDIO_BASE64"
  }
}
EOF
)

    # Call Google STT API
    RESPONSE=$(curl -s -X POST \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$REQUEST_JSON" \
        "https://speech.googleapis.com/v1/speech:recognize")

    # Extract transcript
    TRANSCRIPT=$(echo "$RESPONSE" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if 'results' in data and len(data['results']) > 0:
        print(data['results'][0]['alternatives'][0]['transcript'])
    elif 'error' in data:
        print('ERROR: ' + data['error'].get('message', 'Unknown error'))
    else:
        print('[Empty response]')
except:
    print('[Parse error]')
" 2>/dev/null || echo "[Error parsing response]")

    echo "  Got: $TRANSCRIPT"

    # Check for English words
    if echo "$TRANSCRIPT" | grep -qE '[A-Za-z]{3,}'; then
        echo "  ⚠️  Contains English words"
    else
        echo "  ✅ Pure Arabic transcription"
    fi

    echo ""
}

# Run tests
test_file "test_audio/samples/001001.wav" \
    "Test 1: Professional Recitation (Al-Fatihah 1:1)" \
    "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"

test_file "test_audio/samples/bello.wav" \
    "Test 2: Live Recording 1 (Al-Mu'minun 23:115-116)" \
    "أَفَحَسِبْتُمْ أَنَّمَا خَلَقْنَاكُمْ عَبَثًا..."

test_file "test_audio/samples/bello-1.wav" \
    "Test 3: Live Recording 2 (Al-Isra 17:110)" \
    "قُلِ ادْعُوا اللَّهَ أَوِ ادْعُوا الرَّحْمَٰنَ..."

echo "========================================================================"
echo "Google vs Azure Comparison"
echo "========================================================================"
echo ""
echo "Azure Results (from previous test):"
echo "  Professional: 100% accuracy ✅"
echo "  Live Recording 1: 54% accuracy ❌"
echo "  Live Recording 2: 13% (\"Who do we do\") ❌"
echo ""
echo "Google Results: See above"
echo ""
echo "Decision:"
echo "  If Google shows PURE ARABIC (no English) → Use Google ✅"
echo "  If Google also shows English garbage → STT not viable ❌"
echo ""
