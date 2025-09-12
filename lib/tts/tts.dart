import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class TTSPage extends StatefulWidget {
  const TTSPage({super.key});

  @override
  State<TTSPage> createState() => TTSPageState();
}

class TTSPageState extends State<TTSPage> with TickerProviderStateMixin{
  
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  
  // Voice Settings
  String selectedVoice = 'Female';
  String selectedAccent = 'US English';
  String selectedLanguage = 'English';
  double pitch = 1.0;
  double speechRate = 1.0;
  double volume = 1.0;
  
  // State variables
  bool isPlaying = false;
  bool isPaused = false;
  String currentText = '';
  
  // Mock data for favorites and history
  List<String> favoriteTexts = [
    "Welcome to our Text-to-Speech application",
    "Flutter makes mobile development easy",
  ];
  
  List<Map<String, dynamic>> historyItems = [
    {
      'text': 'Hello world, this is a test message',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'duration': '0:05'
    },
    {
      'text': 'Flutter Text-to-Speech tutorial',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'duration': '0:12'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Widget _buildTextInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter Text to Speak',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _textController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Type or paste your text here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _playText,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(isPlaying ? 'Pause' : 'Play'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _stopText,
                icon: const Icon(Icons.stop),
                label: const Text('Stop'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _saveAsAudio,
                  icon: const Icon(Icons.download),
                  label: const Text('Save as MP3'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _addToFavorites,
                icon: const Icon(Icons.favorite_border),
                label: const Text('Add to Favorites'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Voice Customization',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Voice Gender
          _buildSettingsCard(
            'Voice Gender',
            DropdownButton<String>(
              value: selectedVoice,
              isExpanded: true,
              onChanged: (String? value) {
                setState(() {
                  selectedVoice = value!;
                });
              },
              items: ['Male', 'Female', 'Child']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          
          // Accent Selection
          _buildSettingsCard(
            'Accent',
            DropdownButton<String>(
              value: selectedAccent,
              isExpanded: true,
              onChanged: (String? value) {
                setState(() {
                  selectedAccent = value!;
                });
              },
              items: ['US English', 'British English', 'Australian English', 'Canadian English']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          
          // Language Selection
          _buildSettingsCard(
            'Language',
            DropdownButton<String>(
              value: selectedLanguage,
              isExpanded: true,
              onChanged: (String? value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
              items: ['English', 'Spanish', 'French', 'German', 'Italian', 'Japanese']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          
          // Speech Rate
          _buildSliderCard('Speech Rate', speechRate, 0.5, 2.0, (value) {
            setState(() {
              speechRate = value;
            });
          }),
          
          // Pitch
          _buildSliderCard('Pitch', pitch, 0.5, 2.0, (value) {
            setState(() {
              pitch = value;
            });
          }),
          
          // Volume
          _buildSliderCard('Volume', volume, 0.0, 1.0, (value) {
            setState(() {
              volume = value;
            });
          }),
          
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _testVoiceSettings,
              icon: const Icon(Icons.hearing),
              label: const Text('Test Voice Settings'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard(String title, double value, double min, double max, Function(double) onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: 15,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: _clearHistory,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.history),
                    ),
                    title: Text(
                      item['text'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${_formatDateTime(item['timestamp'])} • Duration: ${item['duration']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _playHistoryItem(item['text']),
                          icon: const Icon(Icons.play_arrow),
                        ),
                        IconButton(
                          onPressed: () => _addToFavoritesFromHistory(item['text']),
                          icon: const Icon(Icons.favorite_border),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavorites() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favorites',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: favoriteTexts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No favorites yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          'Add texts to favorites for quick access',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: favoriteTexts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.favorite, color: Colors.white),
                          ),
                          title: Text(
                            favoriteTexts[index],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _playFavoriteItem(favoriteTexts[index]),
                                icon: const Icon(Icons.play_arrow),
                              ),
                              IconButton(
                                onPressed: () => _removeFromFavorites(index),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentReader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Document & Web Reader',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // File Upload Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload Documents',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _pickPDFFile,
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('Upload PDF'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _pickDocxFile,
                          icon: const Icon(Icons.description),
                          label: const Text('Upload DOCX'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Web Content Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Read Web Content',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'Enter URL (e.g., https://example.com)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.link),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _readWebContent,
                      icon: const Icon(Icons.web),
                      label: const Text('Read Web Page'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Document Preview Section
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Document Preview',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.description, size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'No document loaded',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: null, // Enable when document is loaded
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Read Document'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: null, // Enable when document is loaded
                          icon: const Icon(Icons.download),
                          label: const Text('Save Audio'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text-to-Speech Pro'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.text_fields), text: 'Text Input'),
            Tab(icon: Icon(Icons.tune), text: 'Voice Settings'),
            Tab(icon: Icon(Icons.history), text: 'History'),
            Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
            Tab(icon: Icon(Icons.description), text: 'Documents'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTextInput(),
          _buildVoiceSettings(),
          _buildHistory(),
          _buildFavorites(),
          _buildDocumentReader(),
        ],
      ),
    );
  }

  // Action methods
  void _playText() {
    if (_textController.text.isEmpty) {
      _showSnackBar('Please enter some text to speak');
      return;
    }
    
    setState(() {
      isPlaying = !isPlaying;
      currentText = _textController.text;
    });
    
    // Add to history
    _addToHistory(_textController.text);
    
    _showSnackBar(isPlaying ? 'Playing...' : 'Paused');
  }

  void _stopText() {
    setState(() {
      isPlaying = false;
      isPaused = false;
    });
    _showSnackBar('Stopped');
  }

  void _saveAsAudio() {
    if (_textController.text.isEmpty) {
      _showSnackBar('No text to save');
      return;
    }
    _showSnackBar('Audio saved as MP3');
  }

  void _addToFavorites() {
    if (_textController.text.isEmpty) {
      _showSnackBar('No text to add to favorites');
      return;
    }
    
    if (!favoriteTexts.contains(_textController.text)) {
      setState(() {
        favoriteTexts.add(_textController.text);
      });
      _showSnackBar('Added to favorites');
    } else {
      _showSnackBar('Already in favorites');
    }
  }

  void _testVoiceSettings() {
    _showSnackBar('Testing voice: $selectedVoice, $selectedAccent, Rate: ${speechRate.toStringAsFixed(1)}');
  }

  void _addToHistory(String text) {
    setState(() {
      historyItems.insert(0, {
        'text': text,
        'timestamp': DateTime.now(),
        'duration': '0:${(text.length / 20).round().toString().padLeft(2, '0')}'
      });
    });
  }

  void _clearHistory() {
    setState(() {
      historyItems.clear();
    });
    _showSnackBar('History cleared');
  }

  void _playHistoryItem(String text) {
    _textController.text = text;
    _playText();
  }

  void _addToFavoritesFromHistory(String text) {
    if (!favoriteTexts.contains(text)) {
      setState(() {
        favoriteTexts.add(text);
      });
      _showSnackBar('Added to favorites');
    } else {
      _showSnackBar('Already in favorites');
    }
  }

  void _playFavoriteItem(String text) {
    _textController.text = text;
    _tabController.animateTo(0); // Switch to text input tab
    _playText();
  }

  void _removeFromFavorites(int index) {
    setState(() {
      favoriteTexts.removeAt(index);
    });
    _showSnackBar('Removed from favorites');
  }

  void _pickPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      _showSnackBar('PDF file selected: ${result.files.single.name}');
      // TODO: Implement PDF text extraction
    }
  }

  void _pickDocxFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx', 'doc'],
    );

    if (result != null) {
      _showSnackBar('DOCX file selected: ${result.files.single.name}');
      // TODO: Implement DOCX text extraction
    }
  }

  void _readWebContent() {
    if (_urlController.text.isEmpty) {
      _showSnackBar('Please enter a URL');
      return;
    }
    
    _showSnackBar('Loading web content...');
    // TODO: Implement web content extraction
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}


