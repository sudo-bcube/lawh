#!/usr/bin/env dart
/// Comprehensive Azure STT Accuracy Test Suite for Lawh
///
/// Usage:
///   dart scripts/accuracy_test_suite.dart <AZURE_API_KEY> [region]
///
/// Example:
///   dart scripts/accuracy_test_suite.dart abc123def456 eastus
///
/// Requirements:
///   - dart pub add dio
///   - Test audio files in test_audio/samples/ directory
///   - Audio files must be WAV format, 16kHz, mono

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

void main(List<String> args) async {
  print('=' * 80);
  print('Lawh - Comprehensive Azure STT Accuracy Test Suite');
  print('=' * 80);
  print('');

  // Check for API key argument
  if (args.isEmpty) {
    print('❌ Error: API key required');
    print('');
    print('Usage:');
    print('  dart scripts/accuracy_test_suite.dart <AZURE_API_KEY> [region]');
    print('');
    print('Example:');
    print('  dart scripts/accuracy_test_suite.dart abc123xyz eastus');
    print('');
    exit(1);
  }

  final apiKey = args[0];
  final region = args.length > 1 ? args[1] : 'eastus';

  // Run comprehensive test suite
  final suite = AccuracyTestSuite(apiKey, region);
  await suite.runAllTests();
}

class AccuracyTestSuite {
  final String apiKey;
  final String region;
  final List<TestResult> results = [];

  AccuracyTestSuite(this.apiKey, this.region);

  Future<void> runAllTests() async {
    print('Configuration:');
    print('  API Key: ${apiKey.substring(0, min(8, apiKey.length))}...');
    print('  Region: $region');
    print('');

    // Test categories
    await testCategory1_ClearRecitations();
    await testCategory2_DifferentReciters();
    await testCategory3_LongVerses();
    await testCategory4_ShortVerses();
    await testCategory5_NoisyEnvironments();

    // Generate comprehensive report
    generateReport();
  }

  /// Category 1: Clear recitations from famous reciter
  Future<void> testCategory1_ClearRecitations() async {
    print('─' * 80);
    print('Category 1: Clear Recitations (Baseline)');
    print('─' * 80);
    print('');

    final tests = [
      (
        'test_audio/samples/001001.wav',
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        '1:1',
        'Clear - Alafasy'
      ),
      (
        'test_audio/samples/001002.wav',
        'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        '1:2',
        'Clear - Alafasy'
      ),
      (
        'test_audio/samples/001003.wav',
        'الرَّحْمَٰنِ الرَّحِيمِ',
        '1:3',
        'Clear - Alafasy'
      ),
      (
        'test_audio/samples/001004.wav',
        'مَالِكِ يَوْمِ الدِّينِ',
        '1:4',
        'Clear - Alafasy'
      ),
    ];

    for (final test in tests) {
      await runSingleTest(test.$1, test.$2, test.$3, test.$4);
    }
  }

  /// Category 2: Different reciters (same verses)
  Future<void> testCategory2_DifferentReciters() async {
    print('');
    print('─' * 80);
    print('Category 2: Different Reciters');
    print('─' * 80);
    print('');

    final tests = [
      (
        'test_audio/samples/sudais_001001.wav',
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        '1:1',
        'Sudais'
      ),
      (
        'test_audio/samples/husary_001001.wav',
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        '1:1',
        'Husary'
      ),
      (
        'test_audio/samples/minshawi_001001.wav',
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        '1:1',
        'Minshawi'
      ),
    ];

    for (final test in tests) {
      await runSingleTest(test.$1, test.$2, test.$3, test.$4);
    }
  }

  /// Category 3: Long verses
  Future<void> testCategory3_LongVerses() async {
    print('');
    print('─' * 80);
    print('Category 3: Long Verses');
    print('─' * 80);
    print('');

    final tests = [
      (
        'test_audio/samples/002255.wav',
        'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
        '2:255',
        'Long - Ayat al-Kursi'
      ),
    ];

    for (final test in tests) {
      await runSingleTest(test.$1, test.$2, test.$3, test.$4);
    }
  }

  /// Category 4: Short verses
  Future<void> testCategory4_ShortVerses() async {
    print('');
    print('─' * 80);
    print('Category 4: Short Verses');
    print('─' * 80);
    print('');

    final tests = [
      ('test_audio/samples/103001.wav', 'وَالْعَصْرِ', '103:1', 'Short - Al-Asr'),
      (
        'test_audio/samples/108001.wav',
        'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ',
        '108:1',
        'Short - Al-Kawthar'
      ),
    ];

    for (final test in tests) {
      await runSingleTest(test.$1, test.$2, test.$3, test.$4);
    }
  }

  /// Category 5: Noisy environments (if available)
  Future<void> testCategory5_NoisyEnvironments() async {
    print('');
    print('─' * 80);
    print('Category 5: Noisy Environments');
    print('─' * 80);
    print('');

    final tests = [
      (
        'test_audio/noisy/mosque_001001.wav',
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        '1:1',
        'Noisy - Mosque echo'
      ),
      (
        'test_audio/noisy/outdoor_001001.wav',
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        '1:1',
        'Noisy - Outdoor'
      ),
    ];

    for (final test in tests) {
      final file = File(test.$1);
      if (await file.exists()) {
        await runSingleTest(test.$1, test.$2, test.$3, test.$4);
      }
    }
  }

  /// Run single test
  Future<void> runSingleTest(
    String audioPath,
    String expected,
    String reference,
    String category,
  ) async {
    try {
      final file = File(audioPath);
      if (!await file.exists()) {
        print('⊘ Skipped: $reference ($category) - File not found');
        return;
      }

      final audioBytes = await file.readAsBytes();
      final transcription = await transcribeAudio(audioBytes);

      final accuracy = calculateAccuracy(expected, transcription);
      final passed = accuracy >= 0.85;

      final symbol = passed ? '✓' : '✗';
      final accuracyStr = '${(accuracy * 100).toStringAsFixed(1)}%';

      print('$symbol $reference ($category): $accuracyStr');
      if (!passed && transcription.isNotEmpty) {
        print('    Expected: $expected');
        print('    Got:      $transcription');
      }

      results.add(TestResult(
        reference: reference,
        category: category,
        expected: expected,
        actual: transcription,
        accuracy: accuracy,
        passed: passed,
      ));
    } catch (e) {
      print('✗ $reference ($category): Error - ${e.toString().substring(0, min(60, e.toString().length))}');
      results.add(TestResult(
        reference: reference,
        category: category,
        expected: expected,
        actual: '',
        accuracy: 0.0,
        passed: false,
        error: e.toString(),
      ));
    }
  }

  /// Transcribe audio with Azure STT
  Future<String> transcribeAudio(Uint8List audioData) async {
    final dio = Dio();

    final response = await dio.post(
      'https://$region.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1',
      data: audioData,
      queryParameters: {
        'language': 'ar-SA',
        'format': 'simple',
      },
      options: Options(
        headers: {
          'Ocp-Apim-Subscription-Key': apiKey,
          'Content-Type': 'audio/wav',
        },
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    return response.data['DisplayText'] ?? '';
  }

  /// Calculate accuracy using Levenshtein distance
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

  /// Remove diacritics and normalize Arabic text
  String cleanArabicText(String text) {
    // Remove Arabic diacritics
    final noDiacritics = text.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
    // Keep only Arabic letters and spaces
    final arabicOnly = noDiacritics.replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');
    // Normalize spaces
    return arabicOnly.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Calculate Levenshtein distance
  int levenshteinDistance(String s1, String s2) {
    final len1 = s1.length;
    final len2 = s2.length;
    final matrix = List.generate(len1 + 1, (i) => List.filled(len2 + 1, 0));

    for (var i = 0; i <= len1; i++) matrix[i][0] = i;
    for (var j = 0; j <= len2; j++) matrix[0][j] = j;

    for (var i = 1; i <= len1; i++) {
      for (var j = 1; j <= len2; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[len1][len2];
  }

  /// Generate comprehensive report
  void generateReport() {
    print('');
    print('=' * 80);
    print('Comprehensive Test Report');
    print('=' * 80);
    print('');

    if (results.isEmpty) {
      print('❌ No tests were run. Check:');
      print('  1. Audio files exist in test_audio/samples/');
      print('  2. Files are in WAV format (16kHz mono)');
      print('  3. File paths match test definitions');
      return;
    }

    // Overall statistics
    final totalTests = results.length;
    final passedTests = results.where((r) => r.passed).length;
    final failedTests = totalTests - passedTests;
    final averageAccuracy = results.isEmpty
        ? 0.0
        : results.map((r) => r.accuracy).reduce((a, b) => a + b) / totalTests;

    print('Overall Statistics:');
    print('  Total Tests: $totalTests');
    print('  Passed (≥85%): $passedTests');
    print('  Failed (<85%): $failedTests');
    print('  Pass Rate: ${((passedTests / totalTests) * 100).toStringAsFixed(1)}%');
    print('  Average Accuracy: ${(averageAccuracy * 100).toStringAsFixed(1)}%');
    print('');

    // Category breakdown
    print('Category Breakdown:');
    final categories = results.map((r) => r.category).toSet();
    for (final category in categories) {
      final categoryResults = results.where((r) => r.category == category).toList();
      final categoryPassed = categoryResults.where((r) => r.passed).length;
      final categoryTotal = categoryResults.length;
      final categoryAvg = categoryResults.isEmpty
          ? 0.0
          : categoryResults.map((r) => r.accuracy).reduce((a, b) => a + b) /
              categoryResults.length;

      print('  $category: ${(categoryAvg * 100).toStringAsFixed(1)}% '
          '($categoryPassed/$categoryTotal passed)');
    }
    print('');

    // Decision matrix
    print('=' * 80);
    final passRate = passedTests / totalTests;

    if (averageAccuracy >= 0.85 && passRate >= 0.8) {
      print('✅ DECISION: PROCEED WITH AZURE STT');
      print('');
      print('Rationale:');
      print('  • Average accuracy ${(averageAccuracy * 100).toStringAsFixed(1)}% meets 85% threshold');
      print('  • ${(passRate * 100).toStringAsFixed(0)}% of tests passed');
      print('  • Suitable for MVP deployment');
      print('');
      print('Next Steps:');
      print('  1. Implement Azure STT integration in app');
      print('  2. Build fuzzy matching algorithm');
      print('  3. Test with real user recordings in mosque environments');
    } else if (averageAccuracy >= 0.70) {
      print('⚠️  DECISION: CONDITIONAL PROCEED');
      print('');
      print('Rationale:');
      print('  • Accuracy ${(averageAccuracy * 100).toStringAsFixed(1)}% is moderate (70-84%)');
      print('  • May work for MVP with limitations');
      print('');
      print('Required Actions Before Proceeding:');
      print('  1. Test with more diverse audio samples (10+ more tests)');
      print('  2. Implement audio preprocessing (noise reduction)');
      print('  3. Evaluate Google Cloud STT as backup option');
      print('  4. Set user expectations (show confidence scores)');
    } else {
      print('❌ DECISION: DO NOT PROCEED WITH AZURE STT');
      print('');
      print('Rationale:');
      print('  • Accuracy ${(averageAccuracy * 100).toStringAsFixed(1)}% too low (<70%)');
      print('  • Will not meet MVP success criteria (85%+ required)');
      print('');
      print('Alternative Actions:');
      print('  1. Test Google Cloud Speech-to-Text');
      print('  2. Test AssemblyAI or Speechmatics');
      print('  3. Consider audio fingerprinting approach');
      print('  4. Reevaluate technical feasibility of MVP');
    }
    print('=' * 80);

    // Save detailed report to file
    saveDetailedReport(averageAccuracy, passRate);
  }

  /// Save detailed report to JSON file
  void saveDetailedReport(double avgAccuracy, double passRate) {
    final report = {
      'timestamp': DateTime.now().toIso8601String(),
      'azure_region': region,
      'summary': {
        'total_tests': results.length,
        'passed': results.where((r) => r.passed).length,
        'failed': results.where((r) => !r.passed).length,
        'pass_rate': passRate,
        'average_accuracy': avgAccuracy,
      },
      'recommendation': _getRecommendation(avgAccuracy, passRate),
      'tests': results.map((r) => r.toJson()).toList(),
    };

    try {
      final file = File('test_results/azure_stt_accuracy_report.json');
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(report),
      );

      print('');
      print('📄 Detailed report saved to: ${file.path}');
    } catch (e) {
      print('');
      print('⚠️  Could not save report: $e');
    }
  }

  String _getRecommendation(double avgAccuracy, double passRate) {
    if (avgAccuracy >= 0.85 && passRate >= 0.8) {
      return 'PROCEED';
    } else if (avgAccuracy >= 0.70) {
      return 'CONDITIONAL';
    } else {
      return 'DO_NOT_PROCEED';
    }
  }

  int min(int a, int b) => a < b ? a : b;
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

  Map<String, dynamic> toJson() => {
        'reference': reference,
        'category': category,
        'expected': expected,
        'actual': actual,
        'accuracy': accuracy,
        'passed': passed,
        if (error != null) 'error': error,
      };
}
