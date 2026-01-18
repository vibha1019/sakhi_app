import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketingAIService {
  final String apiKey;

  MarketingAIService(this.apiKey);

  Future<String> generateWhatsAppAd({
    required String product,
    required String description,
    String? price,
  }) async {
    // We use 1.5-flash as it usually has a more stable quota than 2.0
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "Write a catchy WhatsApp ad with emojis for: Product: $product, Info: $description, Price: $price"}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        // If quota exceeded (429) or any other error, use the Fallback
        print("AI Quota hit or error. Using Smart Fallback.");
        return _generateSmartFallback(product, description, price);
      }
    } catch (e) {
      return _generateSmartFallback(product, description, price);
    }
  }

  // This ensures the app "Works all the time"
  String _generateSmartFallback(String product, String description, String? price) {
    return '''
🌟 *SPECIAL OFFER: ${product.toUpperCase()}* 🌟

${description}

💰 *Price:* ${price ?? "Contact for best deal"}

✅ Professional Quality
✅ Trusted Service
✅ Available Now

Click below to chat with us and order yours today! 👇
[Insert WhatsApp Link]
    ''';
  }
}