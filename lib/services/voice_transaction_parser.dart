import 'package:http/http.dart' as http;
import 'dart:convert';

class VoiceTransactionParser {
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<Map<String, dynamic>> parseVoiceInput(String voiceText) async {
    try {
      final apiKey = "I'll put it later";
      final prompt = '''
Parse this transaction statement into structured data:
"$voiceText"

Extract:
1. Type: "income" or "expense"
2. Amount: numerical value only
3. Description: preserve meaning

Rules:
- earned/made/sold/got/received = income
- spent/bought/paid/purchased = expense

Return ONLY valid JSON with no markdown, no code fences, no explanation:
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
          "temperature": 0.2,
        }),
      );

      if (response.statusCode != 200) {
        return {'success': false, 'error': 'API error: ${response.statusCode}'};
      }

      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'] as String;

      // ✅ Strip markdown code fences GPT sometimes adds
      final cleaned = content
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final parsed = jsonDecode(cleaned);

      // ✅ Validate required fields are present and correct types
      if (parsed['type'] == null ||
          parsed['amount'] == null ||
          parsed['description'] == null) {
        return {'success': false, 'error': 'Missing fields in response'};
      }

      if (parsed['type'] != 'income' && parsed['type'] != 'expense') {
        return {'success': false, 'error': 'Invalid transaction type'};
      }

      return {
        'success': true,
        'type': parsed['type'] as String,
        'amount': (parsed['amount'] as num).toDouble(),
        'description': parsed['description'] as String,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}