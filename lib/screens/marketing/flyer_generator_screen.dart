import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:micromitra/services/marketing_ai_service.dart';

class FlyerGeneratorScreen extends StatefulWidget {
  const FlyerGeneratorScreen({super.key});

  @override
  State<FlyerGeneratorScreen> createState() => _FlyerGeneratorScreenState();
}

class _FlyerGeneratorScreenState extends State<FlyerGeneratorScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController offerController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  String? generatedFlyer;
  bool isLoading = false;
  MarketingAIService? aiService;

  // The color matches the pink theme you set in the Marketing Hub
  final Color themeColor = const Color(0xFFFF6B9D);

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey != null) {
      aiService = MarketingAIService(apiKey);
    }
  }

  void generateFlyer() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in the Event/Product Name and Description")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      generatedFlyer = null;
    });

    try {
      // Assuming you will add this method to your MarketingAIService
      final flyerText = await aiService!.generateFlyer(
        title: titleController.text,
        description: descriptionController.text,
        specialOffer: offerController.text.isEmpty ? null : offerController.text,
        contactInfo: contactController.text.isEmpty ? null : contactController.text,
      );

      setState(() {
        generatedFlyer = flyerText;
      });
    } catch (e) {
      setState(() {
        generatedFlyer = "Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    if (generatedFlyer != null) {
      Clipboard.setData(ClipboardData(text: generatedFlyer!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Flyer text copied to clipboard! Ready to paste into Canva or Word.")),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    offerController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flyer Generator"),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Generate catchy copy for your printed or digital flyers.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Business, Product, or Event Name *",
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "What are you advertising? *",
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: offerController,
              decoration: const InputDecoration(
                labelText: "Special Offer / Discount (Optional)",
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: "Contact Info (Phone, Address, Website)",
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: isLoading ? null : generateFlyer,
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Generate Flyer Text"),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            if (isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator())),

            if (generatedFlyer != null) ...[
              const SizedBox(height: 32),
              const Text("Flyer Blueprint:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Card(
                elevation: 4,
                color: themeColor.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: themeColor.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    generatedFlyer!,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.center, // Flyers often look better centered
                  ),
                ),
              ),
              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy),
                label: const Text("Copy Text for Printing/Design"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: themeColor,
                  side: BorderSide(color: themeColor),
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