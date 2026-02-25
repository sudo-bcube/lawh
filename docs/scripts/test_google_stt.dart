#!/usr/bin/env dart
/// Test Google Cloud Speech-to-Text with Quranic Arabic
///
/// Setup:
///   1. Enable Google Cloud Speech-to-Text API
///   2. Create service account and download JSON key
///   3. Set GOOGLE_APPLICATION_CREDENTIALS environment variable
///   4. dart pub add googleapis_auth http
///
/// Usage:
///   export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json
///   dart scripts/test_google_stt.dart

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('=' * 80);
  print('Google Cloud Speech-to-Text Test');
  print('=' * 80);
  print('');

  // Check for credentials
  final credPath = Platform.environment['GOOGLE_APPLICATION_CREDENTIALS'];
  if (credPath == null || credPath.isEmpty) {
    print('❌ Error: GOOGLE_APPLICATION_CREDENTIALS not set');
    print('');
    print('Setup:');
    print('1. Download service account JSON key from Google Cloud Console');
    print('2. Run: export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json');
    print('3. Run this script again');
    exit(1);
  }

  print('✓ Credentials found: $credPath');
  print('');

  // Load service account credentials
  final credFile = File(credPath);
  if (!await credFile.exists()) {
    print('❌ Error: Credentials file not found at $credPath');
    exit(1);
  }

  final credJson = jsonDecode(await credFile.readAsString());
  final projectId = credJson['project_id'] as String;
  print('✓ Project: $projectId');
  print('');

  // Get access token
  print('Getting access token...');
  final accessToken = await getAccessToken(credJson);
  print('✓ Access token obtained');
  print('');

  // Test files
  final testFiles = [
    ('test_audio/samples/001001.wav', 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', 'Al-Fatihah 1:1 (Professional)'),
    ('test_audio/samples/bello.wav', 'أَفَحَسِبْتُمْ أَنَّمَا خَلَقْنَاكُمْ عَبَثًا...', 'Live Recording 1 (23:115-116)'),
    ('test_audio/samples/bello-1.wav', 'قُلِ ادْعُوا اللَّهَ أَوِ ادْعُوا الرَّحْمَٰنَ...', 'Live Recording 2 (17:110)'),
  ];

  for (final test in testFiles) {
    await testFile(test.$1, test.$2, test.$3, accessToken);
    print('');
  }

  print('=' * 80);
  print('Summary');
  print('=' * 80);
  print('');
  print('Compare these results with Azure STT:');
  print('- Professional audio: Should be near 100% for both');
  print('- Live recordings: This is the critical test');
  print('');
  print('If Google returns PURE ARABIC (no English garbage), it wins!');
}

Future<void> testFile(
  String path,
  String expected,
  String description,
  String accessToken,
) async {
  print('─' * 80);
  print(description);
  print('─' * 80);

  final file = File(path);
  if (!await file.exists()) {
    print('⊘ Skipped - file not found');
    return;
  }

  try {
    final audioBytes = await file.readAsBytes();
    final base64Audio = base64Encode(audioBytes);

    print('  File: $path (${audioBytes.length} bytes)');
    print('  Expected: $expected');
    print('  Transcribing...');

    final result = await transcribeGoogle(base64Audio, accessToken);

    print('  Got: $result');

    if (result.isEmpty) {
      print('  ❌ Empty transcription');
    } else if (RegExp(r'[A-Za-z]{3,}').hasMatch(result)) {
      print('  ⚠️  Contains English words (possible issue)');
    } else {
      print('  ✅ Pure Arabic transcription');
    }

    final accuracy = calculateAccuracy(expected, result);
    print('  Accuracy: ${(accuracy * 100).toStringAsFixed(1)}%');
  } catch (e) {
    print('  ❌ Error: $e');
  }
}

Future<String> transcribeGoogle(String base64Audio, String accessToken) async {
  final url = 'https://speech.googleapis.com/v1/speech:recognize';

  final requestBody = {
    'config': {
      'encoding': 'LINEAR16',
      'sampleRateHertz': 16000,
      'languageCode': 'ar-SA',
      'enableAutomaticPunctuation': true,
      'model': 'default',
      'useEnhanced': true,
    },
    'audio': {
      'content': base64Audio,
    },
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode != 200) {
    throw Exception('API error ${response.statusCode}: ${response.body}');
  }

  final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
  final results = jsonResponse['results'] as List?;

  if (results == null || results.isEmpty) {
    return '';
  }

  final alternatives = results[0]['alternatives'] as List?;
  if (alternatives == null || alternatives.isEmpty) {
    return '';
  }

  return alternatives[0]['transcript'] as String? ?? '';
}

Future<String> getAccessToken(Map<String, dynamic> credentials) async {
  final privateKey = credentials['private_key'] as String;
  final clientEmail = credentials['client_email'] as String;
  final tokenUri = credentials['token_uri'] as String;

  // Create JWT
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final header = {
    'alg': 'RS256',
    'typ': 'JWT',
  };

  final claimSet = {
    'iss': clientEmail,
    'scope': 'https://www.googleapis.com/auth/cloud-platform',
    'aud': tokenUri,
    'exp': now + 3600,
    'iat': now,
  };

  // For simplicity, use gcloud CLI instead of manual JWT signing
  // User should have already run: gcloud auth application-default login

  final result = await Process.run('gcloud', [
    'auth',
    'application-default',
    'print-access-token',
  ]);

  if (result.exitCode != 0) {
    throw Exception('Failed to get access token. Run: gcloud auth application-default login');
  }

  return (result.stdout as String).trim();
}

double calculateAccuracy(String expected, String actual) {
  final cleanExpected = cleanArabicText(expected);
  final cleanActual = cleanArabicText(actual);

  if (cleanExpected.isEmpty) return 0.0;

  final distance = levenshteinDistance(cleanExpected, cleanActual);
  final maxLength = cleanExpected.length > cleanActual.length
      ? cleanExpected.length
      : cleanActual.length;

  return maxLength == 0 ? 0.0 : 1.0 - (distance / maxLength);
}

String cleanArabicText(String text) {
  final noDiacritics = text.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
  final arabicOnly = noDiacritics.replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');
  return arabicOnly.trim().replaceAll(RegExp(r'\s+'), ' ');
}

int levenshteinDistance(String s1, String s2) {
  final len1 = s1.length;
  final len2 = s2.length;
  final matrix = List.generate(len1 + 1, (i) => List.filled(len2 + 1, 0));

  for (var i = 0; i <= len1; i++) matrix[i][0] = i;
  for (var j = 0; j <= len2; j++) matrix[0][j] = j;

  for (var i = 1; i <= len1; i++) {
    for (var j = 1; j <= len2; j++) {
      final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
      final deletion = matrix[i - 1][j] + 1;
      final insertion = matrix[i][j - 1] + 1;
      final substitution = matrix[i - 1][j - 1] + cost;

      matrix[i][j] = deletion < insertion
          ? (deletion < substitution ? deletion : substitution)
          : (insertion < substitution ? insertion : substitution);
    }
  }

  return matrix[len1][len2];
}
