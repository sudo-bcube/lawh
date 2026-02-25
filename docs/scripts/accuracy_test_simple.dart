#!/usr/bin/env dart
/// Simple Azure STT Accuracy Test (Compatible with Dart 2.x)
///
/// Usage:
///   dart scripts/accuracy_test_simple.dart <AZURE_API_KEY> [region]
///
/// Example:
///   dart scripts/accuracy_test_simple.dart abc123def456 eastus

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

void main(List<String> args) async {
  print('=' * 80);
  print('Lawh - Azure STT Accuracy Test (Simple Version)');
  print('=' * 80);
  print('');

  // Check for API key argument
  if (args.isEmpty) {
    print('❌ Error: API key required');
    print('');
    print('Usage:');
    print('  dart scripts/accuracy_test_simple.dart <AZURE_API_KEY> [region]');
    print('');
    print('Example:');
    print('  dart scripts/accuracy_test_simple.dart abc123xyz eastus');
    print('');
    exit(1);
  }

  final apiKey = args[0];
  final region = args.length > 1 ? args[1] : 'eastus';

  // Run tests
  final suite = AccuracyTestSuite(apiKey, region);
  await suite.runAllTests();
}

class TestCase {
  final String audioPath;
  final String expected;
  final String reference;
  final String category;

  TestCase({
    required this.audioPath,
    required this.expected,
    required this.reference,
    required this.category,
  });
}

class AccuracyTestSuite {
  final String apiKey;
  final String region;
  final List<TestResult> results = [];

  AccuracyTestSuite(this.apiKey, this.region);

  Future<void> runAllTests() async {
    print('Configuration:');
    print('  API Key: ${apiKey.substring(0, apiKey.length < 8 ? apiKey.length : 8)}...');
    print('  Region: $region');
    print('');

    // Define all test cases
    final testCases = <TestCase>[
      // Category 1: Clear Recitations
      TestCase(
        audioPath: 'test_audio/samples/001001.wav',
        expected: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        reference: '1:1',
        category: 'Clear - Alafasy',
      ),
      TestCase(
        audioPath: 'test_audio/samples/001002.wav',
        expected: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        reference: '1:2',
        category: 'Clear - Alafasy',
      ),
      TestCase(
        audioPath: 'test_audio/samples/001003.wav',
        expected: 'الرَّحْمَٰنِ الرَّحِيمِ',
        reference: '1:3',
        category: 'Clear - Alafasy',
      ),
      TestCase(
        audioPath: 'test_audio/samples/001004.wav',
        expected: 'مَالِكِ يَوْمِ الدِّينِ',
        reference: '1:4',
        category: 'Clear - Alafasy',
      ),

      // Category 2: Different Reciters
      TestCase(
        audioPath: 'test_audio/samples/sudais_001001.wav',
        expected: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        reference: '1:1',
        category: 'Sudais',
      ),
      TestCase(
        audioPath: 'test_audio/samples/husary_001001.wav',
        expected: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        reference: '1:1',
        category: 'Husary',
      ),
      TestCase(
        audioPath: 'test_audio/samples/minshawi_001001.wav',
        expected: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        reference: '1:1',
        category: 'Minshawi',
      ),

      // Category 3: Long Verses
      TestCase(
        audioPath: 'test_audio/samples/002255.wav',
        expected: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
        reference: '2:255',
        category: 'Long - Ayat al-Kursi',
      ),

      // Category 4: Short Verses
      TestCase(
        audioPath: 'test_audio/samples/103001.wav',
        expected: 'وَالْعَصْرِ',
        reference: '103:1',
        category: 'Short - Al-Asr',
      ),
      TestCase(
        audioPath: 'test_audio/samples/108001.wav',
        expected: 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ',
        reference: '108:1',
        category: 'Short - Al-Kawthar',
      ),

      // Category 5: Live Recording (bello - both formats)
      // Note: Recording contains verses 23:115-116 together
      TestCase(
        audioPath: 'test_audio/samples/bello.ogg',
        expected: 'أَفَحَسِبْتُمْ أَنَّمَا خَلَقْنَاكُمْ عَبَثًا وَأَنَّكُمْ إِلَيْنَا لَا تُرْجَعُونَ فَتَعَالَى اللَّهُ الْمَلِكُ الْحَقُّ لَا إِلَٰهَ إِلَّا هُوَ رَبُّ الْعَرْشِ الْكَرِيمِ',
        reference: '23:115-116 (OGG)',
        category: 'Live Recording - OGG',
      ),
      TestCase(
        audioPath: 'test_audio/samples/bello.wav',
        expected: 'أَفَحَسِبْتُمْ أَنَّمَا خَلَقْنَاكُمْ عَبَثًا وَأَنَّكُمْ إِلَيْنَا لَا تُرْجَعُونَ فَتَعَالَى اللَّهُ الْمَلِكُ الْحَقُّ لَا إِلَٰهَ إِلَّا هُوَ رَبُّ الْعَرْشِ الْكَرِيمِ',
        reference: '23:115-116 (WAV)',
        category: 'Live Recording - WAV',
      ),

      // Category 6: Live Recording #2 (bello-1)
      // Al-Isra 17:110
      TestCase(
        audioPath: 'test_audio/samples/bello-1.ogg',
        expected: 'قُلِ ادْعُوا اللَّهَ أَوِ ادْعُوا الرَّحْمَٰنَ أَيًّا مَا تَدْعُوا فَلَهُ الْأَسْمَاءُ الْحُسْنَىٰ وَلَا تَجْهَرْ بِصَلَاتِكَ وَلَا تُخَافِتْ بِهَا وَابْتَغِ بَيْنَ ذَٰلِكَ سَبِيلًا',
        reference: '17:110 (OGG)',
        category: 'Live Recording 2 - OGG',
      ),
      TestCase(
        audioPath: 'test_audio/samples/bello-1.wav',
        expected: 'قُلِ ادْعُوا اللَّهَ أَوِ ادْعُوا الرَّحْمَٰنَ أَيًّا مَا تَدْعُوا فَلَهُ الْأَسْمَاءُ الْحُسْنَىٰ وَلَا تَجْهَرْ بِصَلَاتِكَ وَلَا تُخَافِتْ بِهَا وَابْتَغِ بَيْنَ ذَٰلِكَ سَبِيلًا',
        reference: '17:110 (WAV)',
        category: 'Live Recording 2 - WAV',
      ),
    ];

    // Run all tests
    print('Running Tests...');
    print('─' * 80);

    for (final testCase in testCases) {
      await runSingleTest(testCase);
    }

    // Generate report
    generateReport();
  }

  Future<void> runSingleTest(TestCase testCase) async {
    try {
      final file = File(testCase.audioPath);
      if (!await file.exists()) {
        print('⊘ Skipped: ${testCase.reference} (${testCase.category}) - File not found');
        return;
      }

      final audioBytes = await file.readAsBytes();

      // Determine content type based on file extension
      final contentType = testCase.audioPath.endsWith('.ogg')
          ? 'audio/ogg'
          : 'audio/wav';

      final transcription = await transcribeAudio(audioBytes, contentType);

      final accuracy = calculateAccuracy(testCase.expected, transcription);
      final passed = accuracy >= 0.85;

      final symbol = passed ? '✓' : '✗';
      final accuracyStr = '${(accuracy * 100).toStringAsFixed(1)}%';

      print('$symbol ${testCase.reference} (${testCase.category}): $accuracyStr');
      if (!passed && transcription.isNotEmpty) {
        print('    Expected: ${testCase.expected}');
        print('    Got:      $transcription');
      }

      results.add(TestResult(
        reference: testCase.reference,
        category: testCase.category,
        expected: testCase.expected,
        actual: transcription,
        accuracy: accuracy,
        passed: passed,
      ));
    } catch (e) {
      final errorMsg = e.toString();
      final truncated = errorMsg.length > 60 ? errorMsg.substring(0, 60) : errorMsg;
      print('✗ ${testCase.reference} (${testCase.category}): Error - $truncated');
      results.add(TestResult(
        reference: testCase.reference,
        category: testCase.category,
        expected: testCase.expected,
        actual: '',
        accuracy: 0.0,
        passed: false,
        error: errorMsg,
      ));
    }
  }

  Future<String> transcribeAudio(Uint8List audioData, String contentType) async {
    // Try multiple Arabic locale configurations
    final url = 'https://$region.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=ar-SA&format=detailed';

    final request = await HttpClient().postUrl(Uri.parse(url));
    request.headers.set('Ocp-Apim-Subscription-Key', apiKey);
    request.headers.set('Content-Type', contentType);
    // Force Arabic language - disable language detection fallback
    request.headers.set('Accept-Language', 'ar-SA');
    request.add(audioData);

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode != 200) {
      throw Exception('API error ${response.statusCode}: $responseBody');
    }

    final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;

    // Handle both simple and detailed format
    if (jsonResponse.containsKey('DisplayText')) {
      return jsonResponse['DisplayText'] as String? ?? '';
    } else if (jsonResponse.containsKey('NBest')) {
      final nBest = jsonResponse['NBest'] as List?;
      if (nBest != null && nBest.isNotEmpty) {
        return nBest[0]['Display'] as String? ?? '';
      }
    }

    return '';
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
    // Remove Arabic diacritics
    final noDiacritics = text.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
    // Keep only Arabic letters and spaces
    final arabicOnly = noDiacritics.replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');
    // Normalize spaces
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

  void generateReport() {
    print('');
    print('=' * 80);
    print('Test Report');
    print('=' * 80);
    print('');

    if (results.isEmpty) {
      print('❌ No tests were run. Check:');
      print('  1. Audio files exist in test_audio/samples/');
      print('  2. Files are in WAV/OGG format');
      print('  3. Run setup script: python3 scripts/setup_test_audio.py');
      return;
    }

    final totalTests = results.length;
    final passedTests = results.where((r) => r.passed).length;
    final averageAccuracy = results.map((r) => r.accuracy).reduce((a, b) => a + b) / totalTests;

    print('Overall Statistics:');
    print('  Total Tests: $totalTests');
    print('  Passed (≥85%): $passedTests');
    print('  Failed (<85%): ${totalTests - passedTests}');
    print('  Pass Rate: ${((passedTests / totalTests) * 100).toStringAsFixed(1)}%');
    print('  Average Accuracy: ${(averageAccuracy * 100).toStringAsFixed(1)}%');
    print('');

    // Decision
    print('=' * 80);
    final passRate = passedTests / totalTests;

    if (averageAccuracy >= 0.85 && passRate >= 0.8) {
      print('✅ DECISION: PROCEED WITH AZURE STT');
      print('   Average accuracy meets 85% threshold');
      print('   Suitable for MVP deployment');
    } else if (averageAccuracy >= 0.70) {
      print('⚠️  DECISION: CONDITIONAL PROCEED');
      print('   Accuracy is moderate (70-84%)');
      print('   Consider testing more samples or audio preprocessing');
    } else {
      print('❌ DECISION: DO NOT PROCEED');
      print('   Accuracy too low (<70%)');
      print('   Consider alternative STT providers');
    }
    print('=' * 80);
  }
}

class TestResult {
  final String reference;
  final String category;
  final String expected;
  final String actual;
  final double accuracy;
  final bool passed;
  final String? error;

  TestResult({
    required this.reference,
    required this.category,
    required this.expected,
    required this.actual,
    required this.accuracy,
    required this.passed,
    this.error,
  });
}
