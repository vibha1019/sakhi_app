import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart'; // NEW: Import this
import 'package:micromitra/services/marketing_ai_service.dart';

class WhatsAppAdGeneratorScreen extends StatefulWidget {
  const WhatsAppAdGeneratorScreen({super.key});

  @override
  State<WhatsAppAdGeneratorScreen> createState() => _WhatsAppAdGeneratorScreenState();
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
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey != null) aiService = MarketingAIService(apiKey);
  }

  // NEW: Function to open WhatsApp
  Future<void> _shareToWhatsApp() async {
    if (generatedAd == null) return;

    // We encode the text so that spaces and emojis work in a URL
    final message = Uri.encodeComponent(generatedAd!);
    final whatsappUrl = "https://wa.me/?text=$message";
    final uri = Uri.parse(whatsappUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open WhatsApp")),
        );
      }
    } catch (e) {
      debugPrint("Error launching WhatsApp: $e");
    }
  }

  void generateAd() async {
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
        generatedAd = "Error: $e";
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
            // ... (Your existing input fields stay the same) ...
            TextField(
              controller: productController,
              decoration: const InputDecoration(labelText: "Product Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: isLoading ? null : generateAd,
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Generate Ad with AI"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            if (isLoading) const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),

            if (generatedAd != null) ...[
              const SizedBox(height: 32),
              const Text("Ad Preview:", style: TextStyle(fontWeight: FontWeight.bold)),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(generatedAd!),
                ),
              ),
              const SizedBox(height: 16),
              
              // NEW: The WhatsApp Share Button
              ElevatedButton.icon(
                onPressed: _shareToWhatsApp,
                icon: const Icon(Icons.share),
                label: const Text("Share directly to WhatsApp"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF075E54), // Darker WhatsApp Green
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}