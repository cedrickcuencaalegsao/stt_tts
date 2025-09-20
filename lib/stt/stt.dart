import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class STTPage extends StatefulWidget {
  const STTPage({super.key});

  @override
  State<STTPage> createState() => STTPageState();
}

class STTPageState extends State<STTPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Speech to text";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {},
        onError: (error) {},
      );
      if (available) {
        setState(() => _isListening = true);
        // Try Cebuano first, fallback to Tagalog, then default
        List<String> preferredLocales = [
          'ceb_PH', // Cebuano (Philippines)
          'fil_PH', // Filipino/Tagalog (Philippines)
          'tl_PH',  // Tagalog (Philippines)
        ];
        String? localeId;
        final locales = await _speech.locales();
        for (final pref in preferredLocales) {
          if (locales.any((l) => l.localeId == pref)) {
            localeId = pref;
            break;
          }
        }
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
          localeId: localeId,
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Speech to text steady above the box
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                _text,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              margin: const EdgeInsets.fromLTRB(24.0, 100.0, 24.0, 100.0),
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: Colors.grey.shade300, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              // The box is now empty or can contain other widgets if needed
              child: const SizedBox.shrink(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: FloatingActionButton(
                onPressed: _listen,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
