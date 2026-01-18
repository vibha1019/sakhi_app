import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:micromitra/services/marketing_ai_service.dart';

class WhatsAppAdGeneratorScreen extends StatefulWidget {
  const WhatsAppAdGeneratorScreen({super.key});

  @override
  State<WhatsAppAdGeneratorScreen> createState() =>
      _WhatsAppAdGeneratorScreenState();
}

class _WhatsAppAdGeneratorScreenState extends State<WhatsAppAdGeneratorScreen> {
  final TextEditingController productController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? generatedAd;
  bool isLoading = false;
  MarketingAIService? aiService;

  @override
  void initState() {
    super.initState();
    _initService();
  }

  void _initService() {
    final apiKey = dotenv.env['GEMINI_API_KEY']; // Changed name for clarity
    if (apiKey != null && apiKey.isNotEmpty) {
      aiService = MarketingAIService(apiKey);
    }
  }

  void generateAd() async {
    if (aiService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("API Key not found in .env file")),
      );
      return;
    }

    if (productController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in required fields")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      generatedAd = null;
    });

    try {
      final ad = await aiService!.generateWhatsAppAd(
        product: productController.text,
        description: descriptionController.text,
        price: priceController.text.isEmpty ? null : priceController.text,
      );

      setState(() {
        generatedAd = ad;
      });
    } catch (e) {
      setState(() {
        generatedAd = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp Ad Generator"),
        backgroundColor: const Color(0xFF25D366),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: const Color(0xFF25D366).withOpacity(0.1),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 36, color: Color(0xFF25D366)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text("Gemini AI powered ad generator"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: productController,
              decoration: const InputDecoration(
                  labelText: "Product/Service Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: "Main Benefits/Description", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                  labelText: "Price (Optional)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : generateAd,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text("Generate WhatsApp Ad"),
            ),
            if (generatedAd != null) ...[
              const SizedBox(height: 32),
              const Text("Your Ad Result:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SelectableText(
                generatedAd!,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ]
          ],
        ),
      ),
    );
  }
}