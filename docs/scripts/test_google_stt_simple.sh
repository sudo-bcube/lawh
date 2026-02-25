#!/bin/bash
# Simple Google Cloud STT Test (API Key Only - No SDK Required)
#
# Usage: ./scripts/test_google_stt_simple.sh YOUR_API_KEY

set -e

if [ -z "$1" ]; then
    echo "❌ Error: API key required"
    echo ""
    echo "Usage:"
    echo "  ./scripts/test_google_stt_simple.sh YOUR_GOOGLE_API_KEY"
    echo ""
    echo "Get API Key:"
    echo "  1. Go to https://console.cloud.google.com"
    echo "  2. Create project → Enable Speech-to-Text API"
    echo "  3. APIs & Services → Credentials → Create API Key"
    exit 1
fi

API_KEY=$1

echo "========================================================================"
echo "Google Cloud Speech-to-Text Test (Simple Version)"
echo "========================================================================"
echo ""
echo "API Key: ${API_KEY:0:10}..."
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

    # Encode audio to base64 (no line breaks)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        AUDIO_BASE64=$(base64 -i "$FILE_PATH" | tr -d '\n')
    else
        # Linux
        AUDIO_BASE64=$(base64 -w 0 "$FILE_PATH")
    fi

    # Create request JSON
    REQUEST_JSON=$(cat <<EOF
{
  "config": {
    "encoding": "LINEAR16",
    "sampleRateHertz": 16000,
    "languageCode": "ar-SA",
    "enableAutomaticPunctuation": true
  },
  "audio": {
    "content": "$AUDIO_BASE64"
  }
}
EOF
)

    # Call Google STT API with API key
    RESPONSE=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$REQUEST_JSON" \
        "https://speech.googleapis.com/v1/speech:recognize?key=$API_KEY")

    # Extract transcript using Python (built-in on macOS)
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
except Exception as e:
    print('[Parse error: ' + str(e) + ']')
" 2>/dev/null || echo "[Error parsing response]")

    echo "  Got: $TRANSCRIPT"

    # Check if contains English
    if echo "$TRANSCRIPT" | grep -qE '[A-Za-z]{3,}' && ! echo "$TRANSCRIPT" | grep -q "ERROR"; then
        echo "  ⚠️  WARNING: Contains English words (language detection issue)"
    elif echo "$TRANSCRIPT" | grep -q "ERROR"; then
        echo "  ❌ FAILED: API error"
    else
        echo "  ✅ SUCCESS: Pure Arabic transcription"
    fi

    echo ""
}

# Run tests
echo "Running 3 tests..."
echo ""

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
echo "COMPARISON: Google vs Azure"
echo "========================================================================"
echo ""
echo "Azure STT Results (from previous tests):"
echo "  Test 1 (Professional):  100% accuracy ✅"
echo "  Test 2 (Live Rec 1):    54% - 'Switch ing and collect ion...' ❌"
echo "  Test 3 (Live Rec 2):    13% - 'Who do we do الرحمان...' ❌"
echo ""
echo "Google STT Results: See above ☝️"
echo ""
echo "========================================================================"
echo "DECISION"
echo "========================================================================"
echo ""
echo "IF Google shows PURE ARABIC (no English) for live recordings:"
echo "  → ✅ Use Google Cloud STT for MVP"
echo ""
echo "IF Google ALSO shows English garbage like Azure:"
echo "  → ❌ STT approach NOT viable"
echo "  → Consider alternative: Audio fingerprinting (Shazam-like)"
echo ""
