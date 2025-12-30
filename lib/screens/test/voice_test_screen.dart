import 'package:flutter/material.dart';
import '../../widgets/common/voice_input_button.dart';

class VoiceTestScreen extends StatefulWidget {
  const VoiceTestScreen({super.key});

  @override
  State<VoiceTestScreen> createState() => _VoiceTestScreenState();
}

class _VoiceTestScreenState extends State<VoiceTestScreen> {
  String _voiceResult = 'Press the microphone to speak...';
  String _selectedLanguage = 'hi-IN'; // Hindi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Input Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Language Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Language:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _LanguageChip(
                          label: '🇮🇳 Hindi',
                          code: 'hi-IN',
                          isSelected: _selectedLanguage == 'hi-IN',
                          onTap: () => setState(() => _selectedLanguage = 'hi-IN'),
                        ),
                        _LanguageChip(
                          label: '🇬🇧 English',
                          code: 'en-US',
                          isSelected: _selectedLanguage == 'en-US',
                          onTap: () => setState(() => _selectedLanguage = 'en-US'),
                        ),
                        _LanguageChip(
                          label: '🇮🇳 Tamil',
                          code: 'ta-IN',
                          isSelected: _selectedLanguage == 'ta-IN',
                          onTap: () => setState(() => _selectedLanguage = 'ta-IN'),
                        ),
                        _LanguageChip(
                          label: '🇮🇳 Telugu',
                          code: 'te-IN',
                          isSelected: _selectedLanguage == 'te-IN',
                          onTap: () => setState(() => _selectedLanguage = 'te-IN'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Voice Result Display
            Card(
              color: const Color(0xFF6B4CE6).withOpacity(0.1),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.mic,
                      size: 48,
                      color: Color(0xFF6B4CE6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'What you said:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _voiceResult,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Instructions
            Card(
              color: const Color(0xFFFFB800).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFFFFB800)),
                        const SizedBox(width: 8),
                        Text(
                          'Test Phrases:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TestPhrase('English: "I earned two hundred rupees today"'),
                    _TestPhrase('Hindi: "मैंने आज दो सौ रुपये कमाए"'),
                    _TestPhrase('Tamil: "நான் இன்று இருநூறு ரூபாய் சம்பாதித்தேன்"'),
                    _TestPhrase('Telugu: "నేను ఈరోజు రెండు వందల రూపాయలు సంపాదించాను"'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: VoiceInputButton(
        language: _selectedLanguage,
        onResult: (text) {
          setState(() {
            _voiceResult = text.isNotEmpty ? text : 'No speech detected';
          });
          
          // Show confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Recognized: $text'),
              backgroundColor: const Color(0xFF06D6A0),
            ),
          );
        },
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.label,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFF6B4CE6).withOpacity(0.2),
      checkmarkColor: const Color(0xFF6B4CE6),
    );
  }
}

class _TestPhrase extends StatelessWidget {
  final String text;

  const _TestPhrase(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}