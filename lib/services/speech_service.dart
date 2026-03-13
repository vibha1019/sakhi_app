import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;

  // Initialize the speech plugin
  Future<bool> initSpeech() async {
    _isAvailable = await _speech.initialize(
      onStatus: (status) => print('Speech Status: $status'),
      onError: (error) => print('Speech Error: $error'),
    );
    return _isAvailable;
  }

  // Start listening and return the text recognized
  void startListening(Function(String) onResult) async {
    if (_isAvailable) {
      await _speech.listen(
        onResult: (result) {
          // result.recognizedWords is the actual text of what they said
          onResult(result.recognizedWords);
        },
      );
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  // Stop listening
  void stopListening() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;
}