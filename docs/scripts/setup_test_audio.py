#!/usr/bin/env python3
"""
Lawh - Test Audio Setup Script (Python version)
Downloads Quranic recitation audio samples for Azure STT testing
"""

import os
import sys
import json
import subprocess
from pathlib import Path
from urllib.request import urlretrieve
from urllib.error import URLError

def print_header(text):
    """Print formatted header"""
    print("=" * 50)
    print(text)
    print("=" * 50)
    print()

def print_section(text):
    """Print section header"""
    print(f"\n{text}")
    print("-" * 50)

def download_file(url, destination, description):
    """Download a file with progress"""
    try:
        print(f"  Downloading {description}...", end=" ", flush=True)
        urlretrieve(url, destination)
        print("✓")
        return True
    except URLError as e:
        print(f"✗ Error: {e}")
        return False

def check_ffmpeg():
    """Check if ffmpeg is installed"""
    try:
        subprocess.run(
            ["ffmpeg", "-version"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True
        )
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False

def convert_to_wav(mp3_path, wav_path):
    """Convert MP3 to WAV using ffmpeg"""
    try:
        subprocess.run(
            [
                "ffmpeg",
                "-i", mp3_path,
                "-ar", "16000",
                "-ac", "1",
                "-acodec", "pcm_s16le",
                wav_path,
                "-y",
                "-loglevel", "error"
            ],
            check=True,
            capture_output=True
        )
        return True
    except subprocess.CalledProcessError as e:
        print(f"  ✗ Error converting {mp3_path}: {e}")
        return False

def main():
    print_header("Lawh - Test Audio Setup")

    # Create directory structure
    print("Creating directory structure...")
    base_dir = Path("test_audio")
    samples_dir = base_dir / "samples"
    noisy_dir = base_dir / "noisy"
    processed_dir = base_dir / "processed"

    samples_dir.mkdir(parents=True, exist_ok=True)
    noisy_dir.mkdir(parents=True, exist_ok=True)
    processed_dir.mkdir(parents=True, exist_ok=True)

    print("✓ Directories created")

    # Define audio files to download
    downloads = [
        # Al-Fatihah (Alafasy)
        ("https://everyayah.com/data/Alafasy_128kbps/001001.mp3", "001001.mp3", "Al-Fatihah 1:1 (Alafasy)"),
        ("https://everyayah.com/data/Alafasy_128kbps/001002.mp3", "001002.mp3", "Al-Fatihah 1:2 (Alafasy)"),
        ("https://everyayah.com/data/Alafasy_128kbps/001003.mp3", "001003.mp3", "Al-Fatihah 1:3 (Alafasy)"),
        ("https://everyayah.com/data/Alafasy_128kbps/001004.mp3", "001004.mp3", "Al-Fatihah 1:4 (Alafasy)"),
        ("https://everyayah.com/data/Alafasy_128kbps/001005.mp3", "001005.mp3", "Al-Fatihah 1:5 (Alafasy)"),
        ("https://everyayah.com/data/Alafasy_128kbps/001006.mp3", "001006.mp3", "Al-Fatihah 1:6 (Alafasy)"),
        ("https://everyayah.com/data/Alafasy_128kbps/001007.mp3", "001007.mp3", "Al-Fatihah 1:7 (Alafasy)"),

        # Ayat al-Kursi
        ("https://everyayah.com/data/Alafasy_128kbps/002255.mp3", "002255.mp3", "Ayat al-Kursi 2:255 (Alafasy)"),

        # Short verses
        ("https://everyayah.com/data/Alafasy_128kbps/103001.mp3", "103001.mp3", "Al-Asr 103:1 (Alafasy)"),
        ("https://everyayah.com/data/Alafasy_128kbps/103002.mp3", "103002.mp3", "Al-Asr 103:2 (Alafasy)"),
        ("https://everyayah.com/data/Alafasy_128kbps/103003.mp3", "103003.mp3", "Al-Asr 103:3 (Alafasy)"),
        ("https://everyayah.com/data/Alafasy_128kbps/108001.mp3", "108001.mp3", "Al-Kawthar 108:1 (Alafasy)"),
        ("https://everyayah.com/data/Alafasy_128kbps/108002.mp3", "108002.mp3", "Al-Kawthar 108:2 (Alafasy)"),
        ("https://everyayah.com/data/Alafasy_128kbps/108003.mp3", "108003.mp3", "Al-Kawthar 108:3 (Alafasy)"),

        # Different reciters
        ("https://everyayah.com/data/Abdurrahmaan_As-Sudais_192kbps/001001.mp3", "sudais_001001.mp3", "Al-Fatihah 1:1 (Sudais)"),
        ("https://everyayah.com/data/Husary_128kbps/001001.mp3", "husary_001001.mp3", "Al-Fatihah 1:1 (Husary)"),
        ("https://everyayah.com/data/Minshawy_Murattal_128kbps/001001.mp3", "minshawi_001001.mp3", "Al-Fatihah 1:1 (Minshawi)"),
    ]

    # Download all files
    print_section("Downloading audio files")
    download_count = 0
    for url, filename, description in downloads:
        destination = samples_dir / filename
        if download_file(url, destination, description):
            download_count += 1

    print(f"\n✓ Downloaded {download_count}/{len(downloads)} files")

    # Check ffmpeg
    print_section("Checking ffmpeg installation")
    if not check_ffmpeg():
        print("✗ ffmpeg is not installed")
        print("\nInstall ffmpeg:")
        print("  macOS:   brew install ffmpeg")
        print("  Ubuntu:  sudo apt-get install ffmpeg")
        print("  Windows: choco install ffmpeg")
        print("\nAfter installing ffmpeg, run this script again to convert audio files.")
        sys.exit(1)

    print("✓ ffmpeg is installed")

    # Convert MP3 to WAV
    print_section("Converting MP3 to WAV (16kHz, mono, 16-bit PCM)")
    mp3_files = list(samples_dir.glob("*.mp3"))
    convert_count = 0

    for mp3_file in mp3_files:
        wav_file = mp3_file.with_suffix(".wav")
        print(f"  Converting {mp3_file.name}...", end=" ", flush=True)
        if convert_to_wav(str(mp3_file), str(wav_file)):
            print("✓")
            convert_count += 1
        else:
            print("✗")

    print(f"\n✓ Converted {convert_count}/{len(mp3_files)} files")

    # Create test metadata
    print_section("Creating test metadata")
    test_cases = {
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

    metadata_file = base_dir / "test_cases.json"
    with open(metadata_file, "w", encoding="utf-8") as f:
        json.dump(test_cases, f, ensure_ascii=False, indent=2)

    print(f"✓ Test metadata saved to {metadata_file}")

    # Print summary
    print_header("Setup Complete!")
    print(f"Summary:")
    print(f"  • Downloaded: {download_count} MP3 files")
    print(f"  • Converted: {convert_count} WAV files")
    print(f"  • Test cases: {metadata_file}")
    print()
    print("Audio format:")
    print("  • Sample rate: 16kHz")
    print("  • Channels: Mono")
    print("  • Format: 16-bit PCM WAV")
    print()
    print("Next steps:")
    print("  1. Set up Azure Speech Service (see docs/test-azure-stt.md)")
    print("  2. Get your Azure API key")
    print("  3. Run: dart scripts/test_azure_stt.dart")
    print()
    print("Test categories:")
    print("  • Clear recitations (7 verses from Al-Fatihah)")
    print("  • Long verses (Ayat al-Kursi)")
    print("  • Short verses (Al-Asr, Al-Kawthar)")
    print("  • Different reciters (Alafasy, Sudais, Husary, Minshawi)")
    print()

if __name__ == "__main__":
    main()
