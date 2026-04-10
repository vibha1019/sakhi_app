import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketingAIService {
  final String apiKey;

  MarketingAIService(this.apiKey);

  // ==========================================
  // WHATSAPP AD GENERATOR
  // ==========================================

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

  // ==========================================
  // FLYER GENERATOR (NEW)
  // ==========================================

  Future<String> generateFlyer({
    required String title,
    required String description,
    String? specialOffer,
    String? contactInfo,
  }) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

    final prompt = '''
    You are an expert marketer and graphic design copywriter.
    Create the text layout for a highly engaging flyer based on the following details:

    Title/Business Name: $title
    Description: $description
    ${specialOffer != null && specialOffer.isNotEmpty ? 'Special Offer: $specialOffer' : ''}
    ${contactInfo != null && contactInfo.isNotEmpty ? 'Contact Info: $contactInfo' : ''}

    Format the output clearly with:
    - A Catchy Main Headline (ALL CAPS)
    - A brief, engaging sub-headline
    - 3 to 4 bullet points highlighting the main benefits
    - A strong Call to Action (CTA)
    - Contact Information at the bottom

    Keep it concise, punchy, and easy to read from a distance. Do not include emojis, as this is for a printed flyer.
    ''';

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print("AI Quota hit or error for flyer. Using Smart Fallback.");
        return _generateFlyerSmartFallback(title, description, specialOffer, contactInfo);
      }
    } catch (e) {
      return _generateFlyerSmartFallback(title, description, specialOffer, contactInfo);
    }
  }

  // Smart fallback for Flyer generator
  String _generateFlyerSmartFallback(String title, String description, String? specialOffer, String? contactInfo) {
    return '''
[ HEADLINE ]
${title.toUpperCase()}

[ ABOUT THIS ]
$description

[ SPECIAL OFFER ]
${(specialOffer != null && specialOffer.isNotEmpty) ? specialOffer : "Ask us about our daily specials!"}

[ WHY CHOOSE US ]
• High Quality Guaranteed
• Fast and Reliable Service
• 100% Customer Satisfaction

[ CONTACT US TODAY ]
${(contactInfo != null && contactInfo.isNotEmpty) ? contactInfo : "Visit us or call today!"}
    ''';
  }
}