import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceInputButton extends StatefulWidget {
  final Function(String) onResult;
  final String? language; // 'en-US', 'hi-IN', 'ta-IN', 'te-IN'
  
  const VoiceInputButton({
    super.key,
    required this.onResult,
    this.language = 'hi-IN',
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _listen,
      backgroundColor: _isListening 
        ? Colors.red 
        : Theme.of(context).colorScheme.primary,
      child: Icon(_isListening ? Icons.mic : Icons.mic_none),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') {
            setState(() => _isListening = false);
            widget.onResult(_text);
          }
        },
        onError: (error) {
          setState(() => _isListening = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${error.errorMsg}')),
          );
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
          localeId: widget.language,
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}