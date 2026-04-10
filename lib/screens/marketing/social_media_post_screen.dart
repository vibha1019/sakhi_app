import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:micromitra/services/marketing_ai_service.dart';

class SocialMediaPostScreen extends StatefulWidget {
  const SocialMediaPostScreen({super.key});

  @override
  State<SocialMediaPostScreen> createState() => _SocialMediaPostScreenState();
}

class _SocialMediaPostScreenState extends State<SocialMediaPostScreen> {
  final TextEditingController topicController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  String selectedPlatform = 'Instagram';
  String selectedTone = 'Exciting & Engaging';

  String? generatedPost;
  bool isLoading = false;
  MarketingAIService? aiService;

  // The purple theme matching your Marketing Hub
  final Color themeColor = const Color(0xFF6B4CE6);

  final List<String> platforms = ['Instagram', 'Facebook', 'LinkedIn', 'X (Twitter)', 'TikTok'];
  final List<String> tones = ['Exciting & Engaging', 'Professional', 'Humorous', 'Informational', 'Urgent / Sales'];

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey != null) {
      aiService = MarketingAIService(apiKey);
    }
  }

  void generatePost() async {
    if (topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a topic or product name")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      generatedPost = null;
    });

    try {
      final post = await aiService!.generateSocialMediaPost(
        platform: selectedPlatform,
        tone: selectedTone,
        topic: topicController.text,
        details: detailsController.text,
      );

      setState(() {
        generatedPost = post;
      });
    } catch (e) {
      setState(() {
        generatedPost = "Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    if (generatedPost != null) {
      Clipboard.setData(ClipboardData(text: generatedPost!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Copied! Ready to paste into $selectedPlatform."),
          backgroundColor: themeColor,
        ),
      );
    }
  }

  @override
  void dispose() {
    topicController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Social Media Creator"),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Create tailored posts for your social media channels with the right hashtags and tone.",
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedPlatform,
                    decoration: const InputDecoration(labelText: "Platform", border: OutlineInputBorder()),
                    items: platforms.map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (newValue) => setState(() => selectedPlatform = newValue!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTone,
                    decoration: const InputDecoration(labelText: "Tone", border: OutlineInputBorder()),
                    items: tones.map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontSize: 14)));
                    }).toList(),
                    onChanged: (newValue) => setState(() => selectedTone = newValue!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                labelText: "Product, Event, or Topic *",
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: detailsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Any specific details, links, or promos? (Optional)",
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: isLoading ? null : generatePost,
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Generate Post"),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            if (isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator())),

            if (generatedPost != null) ...[
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Generated Post:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  IconButton(
                    icon: Icon(Icons.copy, color: themeColor),
                    onPressed: _copyToClipboard,
                    tooltip: "Copy to Clipboard",
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 3,
                color: themeColor.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: themeColor.withOpacity(0.3), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    generatedPost!,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy),
                label: Text("Copy for $selectedPlatform"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
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