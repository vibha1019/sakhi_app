import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceTransactionParser {
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  /// Parse voice input into structured transaction data
  /// Example inputs:
  /// - "I earned 200 rupees today"
  /// - "Spent 50 rupees on thread"
  /// - "Made 500 from selling saree"
Future<Map<String, dynamic>> parseVoiceInput(String voiceText) async {
  final apiKey = dotenv.env['OPENAI_API_KEY'];

  final prompt = '''
Parse this transaction statement into structured data:
"$voiceText"

Extract:
1. Type: "income" or "expense"
2. Amount: numerical value only
3. Description: preserve meaning

Rules:
- earned/made/sold/got = income
- spent/bought/paid = expense

Return ONLY JSON:
{
  "type": "income or expense",
  "amount": number,
  "description": "string"
}
''';

  final response = await http.post(
    Uri.parse(_apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      "model": "gpt-4o-mini",
      "messages": [
        {
          "role": "user",
          "content": prompt,
        }
      ],
      "temperature": 0.2
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('OpenAI API error: ${response.body}');
  }

  final data = jsonDecode(response.body);

  final content = data['choices'][0]['message']['content'];

  return jsonDecode(content);
}
}