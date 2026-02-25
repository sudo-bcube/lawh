#!/bin/bash

# Lawh - Test Audio Setup Script
# Downloads Quranic recitation audio samples for Azure STT testing

set -e  # Exit on error

echo "=========================================="
echo "Lawh - Test Audio Setup"
echo "=========================================="
echo ""

# Create directory structure
echo "Creating directory structure..."
mkdir -p test_audio/samples
mkdir -p test_audio/noisy
mkdir -p test_audio/processed

echo "✓ Directories created"
echo ""

# Download Al-Fatihah verses (Mishary Al-Afasy)
echo "Downloading Al-Fatihah verses (Alafasy)..."
curl -# -o test_audio/samples/001001.mp3 "https://everyayah.com/data/Alafasy_128kbps/001001.mp3"
curl -# -o test_audio/samples/001002.mp3 "https://everyayah.com/data/Alafasy_128kbps/001002.mp3"
curl -# -o test_audio/samples/001003.mp3 "https://everyayah.com/data/Alafasy_128kbps/001003.mp3"
curl -# -o test_audio/samples/001004.mp3 "https://everyayah.com/data/Alafasy_128kbps/001004.mp3"
curl -# -o test_audio/samples/001005.mp3 "https://everyayah.com/data/Alafasy_128kbps/001005.mp3"
curl -# -o test_audio/samples/001006.mp3 "https://everyayah.com/data/Alafasy_128kbps/001006.mp3"
curl -# -o test_audio/samples/001007.mp3 "https://everyayah.com/data/Alafasy_128kbps/001007.mp3"

echo "✓ Al-Fatihah downloaded (Alafasy)"
echo ""

# Download Ayat al-Kursi (2:255)
echo "Downloading Ayat al-Kursi (2:255)..."
curl -# -o test_audio/samples/002255.mp3 "https://everyayah.com/data/Alafasy_128kbps/002255.mp3"
echo "✓ Ayat al-Kursi downloaded"
echo ""

# Download some short verses from different surahs
echo "Downloading short verses..."
curl -# -o test_audio/samples/103001.mp3 "https://everyayah.com/data/Alafasy_128kbps/103001.mp3"  # Al-Asr
curl -# -o test_audio/samples/103002.mp3 "https://everyayah.com/data/Alafasy_128kbps/103002.mp3"
curl -# -o test_audio/samples/103003.mp3 "https://everyayah.com/data/Alafasy_128kbps/103003.mp3"
curl -# -o test_audio/samples/108001.mp3 "https://everyayah.com/data/Alafasy_128kbps/108001.mp3"  # Al-Kawthar
curl -# -o test_audio/samples/108002.mp3 "https://everyayah.com/data/Alafasy_128kbps/108002.mp3"
curl -# -o test_audio/samples/108003.mp3 "https://everyayah.com/data/Alafasy_128kbps/108003.mp3"
echo "✓ Short verses downloaded"
echo ""

# Download same verses from different reciters
echo "Downloading Al-Fatihah from different reciters..."
curl -# -o test_audio/samples/sudais_001001.mp3 "https://everyayah.com/data/Abdurrahmaan_As-Sudais_192kbps/001001.mp3"
curl -# -o test_audio/samples/husary_001001.mp3 "https://everyayah.com/data/Husary_128kbps/001001.mp3"
curl -# -o test_audio/samples/minshawi_001001.mp3 "https://everyayah.com/data/Minshawy_Murattal_128kbps/001001.mp3"
echo "✓ Different reciters downloaded"
echo ""

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "❌ Error: ffmpeg is not installed"
    echo ""
    echo "Install ffmpeg:"
    echo "  macOS:   brew install ffmpeg"
    echo "  Ubuntu:  sudo apt-get install ffmpeg"
    echo "  Windows: choco install ffmpeg"
    echo ""
    echo "After installing ffmpeg, run this script again to convert audio files."
    exit 1
fi

echo "Converting MP3 to WAV format (Azure STT compatible)..."
echo "Format: 16kHz, mono, 16-bit PCM"
echo ""

# Convert all MP3 files to WAV
for file in test_audio/samples/*.mp3; do
    if [ -f "$file" ]; then
        base=$(basename "$file" .mp3)
        echo "  Converting $base.mp3..."
        ffmpeg -i "$file" -ar 16000 -ac 1 -acodec pcm_s16le "test_audio/samples/$base.wav" -y -loglevel error
    fi
done

echo "✓ All files converted to WAV"
echo ""

# Verify converted files
echo "Verifying converted files..."
wav_count=$(ls -1 test_audio/samples/*.wav 2>/dev/null | wc -l)
echo "✓ Found $wav_count WAV files"
echo ""

# Create test metadata file
cat > test_audio/test_cases.json << 'EOF'
{
  "test_cases": [
    {
      "file": "test_audio/samples/001001.wav",
      "expected": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
      "reference": "1:1",
      "category": "clear",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/001002.wav",
      "expected": "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
      "reference": "1:2",
      "category": "clear",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/001003.wav",
      "expected": "الرَّحْمَٰنِ الرَّحِيمِ",
      "reference": "1:3",
      "category": "clear",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/001004.wav",
      "expected": "مَالِكِ يَوْمِ الدِّينِ",
      "reference": "1:4",
      "category": "clear",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/001005.wav",
      "expected": "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
      "reference": "1:5",
      "category": "clear",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/001006.wav",
      "expected": "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ",
      "reference": "1:6",
      "category": "clear",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/001007.wav",
      "expected": "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
      "reference": "1:7",
      "category": "clear",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/002255.wav",
      "expected": "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ",
      "reference": "2:255",
      "category": "long",
      "reciter": "Alafasy",
      "note": "First part of Ayat al-Kursi"
    },
    {
      "file": "test_audio/samples/103001.wav",
      "expected": "وَالْعَصْرِ",
      "reference": "103:1",
      "category": "short",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/103002.wav",
      "expected": "إِنَّ الْإِنْسَانَ لَفِي خُسْرٍ",
      "reference": "103:2",
      "category": "short",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/103003.wav",
      "expected": "إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ",
      "reference": "103:3",
      "category": "short",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/108001.wav",
      "expected": "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ",
      "reference": "108:1",
      "category": "short",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/108002.wav",
      "expected": "فَصَلِّ لِرَبِّكَ وَانْحَرْ",
      "reference": "108:2",
      "category": "short",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/108003.wav",
      "expected": "إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ",
      "reference": "108:3",
      "category": "short",
      "reciter": "Alafasy"
    },
    {
      "file": "test_audio/samples/sudais_001001.wav",
      "expected": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
      "reference": "1:1",
      "category": "different_reciters",
      "reciter": "Sudais"
    },
    {
      "file": "test_audio/samples/husary_001001.wav",
      "expected": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
      "reference": "1:1",
      "category": "different_reciters",
      "reciter": "Husary"
    },
    {
      "file": "test_audio/samples/minshawi_001001.wav",
      "expected": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
      "reference": "1:1",
      "category": "different_reciters",
      "reciter": "Minshawi"
    }
  ]
}
EOF

echo "✓ Test metadata file created"
echo ""

# Print summary
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  • Downloaded: $(ls -1 test_audio/samples/*.mp3 2>/dev/null | wc -l) MP3 files"
echo "  • Converted: $(ls -1 test_audio/samples/*.wav 2>/dev/null | wc -l) WAV files"
echo "  • Test cases: test_audio/test_cases.json"
echo ""
echo "Audio format:"
echo "  • Sample rate: 16kHz"
echo "  • Channels: Mono"
echo "  • Format: 16-bit PCM WAV"
echo ""
echo "Next steps:"
echo "  1. Set up Azure Speech Service (see docs/test-azure-stt.md)"
echo "  2. Get your Azure API key"
echo "  3. Run: dart scripts/test_azure_stt.dart"
echo ""
echo "Test categories:"
echo "  • Clear recitations (7 verses from Al-Fatihah)"
echo "  • Long verses (Ayat al-Kursi)"
echo "  • Short verses (Al-Asr, Al-Kawthar)"
echo "  • Different reciters (Alafasy, Sudais, Husary, Minshawi)"
echo ""
