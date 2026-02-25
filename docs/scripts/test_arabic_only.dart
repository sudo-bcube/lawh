#!/usr/bin/env dart
/// Test Azure STT with STRICT Arabic-only mode
/// Tests different Azure STT configurations to force Arabic recognition

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart scripts/test_arabic_only.dart <AZURE_API_KEY> [region]');
    exit(1);
  }

  final apiKey = args[0];
  final region = args.length > 1 ? args[1] : 'eastus';

  print('=' * 80);
  print('Testing Azure STT - Arabic-Only Mode');
  print('=' * 80);
  print('');

  // Test with bello-1.wav (the clearer recording)
  final audioFile = File('test_audio/samples/bello-1.wav');
  if (!await audioFile.exists()) {
    print('❌ Error: test_audio/samples/bello-1.wav not found');
    exit(1);
  }

  final audioBytes = await audioFile.readAsBytes();
  print('Testing with: bello-1.wav (17:110)');
  print('Expected: قُلِ ادْعُوا اللَّهَ أَوِ ادْعُوا الرَّحْمَٰنَ...');
  print('');

  // Test 1: Default configuration (ar-SA, conversation mode)
  print('─' * 80);
  print('Test 1: Default Configuration (ar-SA, conversation mode)');
  print('─' * 80);
  final result1 = await testConfig1(audioBytes, apiKey, region);
  print('Result: $result1');
  print('');

  // Test 2: Generic Arabic (ar, not ar-SA)
  print('─' * 80);
  print('Test 2: Generic Arabic Locale (ar instead of ar-SA)');
  print('─' * 80);
  final result2 = await testConfig2(audioBytes, apiKey, region);
  print('Result: $result2');
  print('');

  // Test 3: Dictation mode instead of conversation
  print('─' * 80);
  print('Test 3: Dictation Mode (ar-SA, dictation)');
  print('─' * 80);
  final result3 = await testConfig3(audioBytes, apiKey, region);
  print('Result: $result3');
  print('');

  // Test 4: Egyptian Arabic (ar-EG)
  print('─' * 80);
  print('Test 4: Egyptian Arabic Locale (ar-EG)');
  print('─' * 80);
  final result4 = await testConfig4(audioBytes, apiKey, region);
  print('Result: $result4');
  print('');

  // Test 5: With profanity filter off (sometimes helps)
  print('─' * 80);
  print('Test 5: Profanity Filter Disabled');
  print('─' * 80);
  final result5 = await testConfig5(audioBytes, apiKey, region);
  print('Result: $result5');
  print('');

  print('=' * 80);
  print('Summary');
  print('=' * 80);
  print('1. Default (ar-SA, conversation): $result1');
  print('2. Generic (ar): $result2');
  print('3. Dictation mode: $result3');
  print('4. Egyptian (ar-EG): $result4');
  print('5. No profanity filter: $result5');
  print('');
  print('Look for the result with LEAST English and MOST Arabic text.');
}

// Test 1: Default (ar-SA, conversation)
Future<String> testConfig1(Uint8List audio, String key, String region) async {
  return await callAzureSTT(
    audio,
    key,
    region,
    language: 'ar-SA',
    mode: 'conversation',
  );
}

// Test 2: Generic Arabic
Future<String> testConfig2(Uint8List audio, String key, String region) async {
  return await callAzureSTT(
    audio,
    key,
    region,
    language: 'ar',
    mode: 'conversation',
  );
}

// Test 3: Dictation mode
Future<String> testConfig3(Uint8List audio, String key, String region) async {
  return await callAzureSTT(
    audio,
    key,
    region,
    language: 'ar-SA',
    mode: 'dictation',
  );
}

// Test 4: Egyptian Arabic
Future<String> testConfig4(Uint8List audio, String key, String region) async {
  return await callAzureSTT(
    audio,
    key,
    region,
    language: 'ar-EG',
    mode: 'conversation',
  );
}

// Test 5: No profanity filter
Future<String> testConfig5(Uint8List audio, String key, String region) async {
  return await callAzureSTT(
    audio,
    key,
    region,
    language: 'ar-SA',
    mode: 'conversation',
    profanityFilter: 'raw',
  );
}

Future<String> callAzureSTT(
  Uint8List audioData,
  String apiKey,
  String region, {
  required String language,
  required String mode,
  String profanityFilter = 'masked',
}) async {
  try {
    final params = {
      'language': language,
      'format': 'simple',
      'profanity': profanityFilter,
    };

    final queryString = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    final url = 'https://$region.stt.speech.microsoft.com/speech/recognition/$mode/cognitiveservices/v1?$queryString';

    final request = await HttpClient().postUrl(Uri.parse(url));
    request.headers.set('Ocp-Apim-Subscription-Key', apiKey);
    request.headers.set('Content-Type', 'audio/wav');
    request.headers.set('Accept-Language', language);
    request.add(audioData);

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode != 200) {
      return 'ERROR: ${response.statusCode} - $responseBody';
    }

    final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;
    return jsonResponse['DisplayText'] as String? ?? '[Empty response]';
  } catch (e) {
    return 'ERROR: $e';
  }
}
