import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';
import 'package:tflite/tflite.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({Key? key}) : super(key: key);

  @override
  ImagePickerPageState createState() => ImagePickerPageState();
}

class ImagePickerPageState extends State<ImagePickerPage> {
  final List<File> _pickedImages = [];
  final translator = GoogleTranslator();
  String _currentLanguage = 'en'; // Default language is English

  String? appBarText;
  String? getResultsButtonText;
  String? lemonText;
  String? roseText;
  String? marrygoldText;
  String? jasminText;
  String? sunflowerText;
  String? ladyFingerText;

  late List<dynamic> _output;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite', // Replace with your model's path
      labels: 'assets/labels.txt', // Replace with your labels' path
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImages.add(File(pickedImage.path));
      });

      await _runInference(_pickedImages.last);
    }
  }

  Future<void> _runInference(File imageFile) async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      final recognition = await Tflite.runModelOnImage(
        path: imageFile.path,
        numResults: 3, // Adjust the number of results as needed
      );

      setState(() {
        _output = recognition!;
        _isLoading = false;
      });

      if (_output.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Results'),
              content: Column(
                children: [
                  Text('Disease: ${_output[0]['label']}'),
                  Text('Confidence: ${(_output[0]['confidence'] * 100).toStringAsFixed(2)}%'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _translatePage() async {
    if (_currentLanguage == 'ur') {
      return; // Skip translation if already in Urdu
    }

    // Translate text in AppBar
    final appBarTranslation = await translator.translate(
      'Please select the image',
      from: 'en',
      to: 'ur',
    );
    final getResultsButtonTranslation = await translator.translate(
      'Get Results',
      from: 'en',
      to: 'ur',
    );

    // Translate text in category cards
    final lemonTranslation = await translator.translate(
      'Lemon',
      from: 'en',
      to: 'ur',
    );
    final roseTranslation = await translator.translate(
      'Rose',
      from: 'en',
      to: 'ur',
    );
    final marrygoldTranslation = await translator.translate(
      'Marrygold',
      from: 'en',
      to: 'ur',
    );
    final jasminTranslation = await translator.translate(
      'Jasmin',
      from: 'en',
      to: 'ur',
    );
    final sunflowerTranslation = await translator.translate(
      'Sunflower',
      from: 'en',
      to: 'ur',
    );
    final ladyFingerTranslation = await translator.translate(
      'LadyFinger',
      from: 'en',
      to: 'ur',
    );

    setState(() {
      appBarText = appBarTranslation.text;
      getResultsButtonText = getResultsButtonTranslation.text;
      lemonText = lemonTranslation.text;
      roseText = roseTranslation.text;
      marrygoldText = marrygoldTranslation.text;
      jasminText = jasminTranslation.text;
      sunflowerText = sunflowerTranslation.text;
      ladyFingerText = ladyFingerTranslation.text;
    });

    // Translate the remaining text in the app as needed

    // Set the current language to Urdu
    _currentLanguage = 'ur';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText ?? 'Please select the image'),
        backgroundColor: const Color.fromARGB(255, 129, 197, 110),
        actions: [
          IconButton(
            onPressed: _translatePage,
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // Set the background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _pickedImages.isNotEmpty
                  ? Image.file(
                _pickedImages.last,
                height: 250,
                fit: BoxFit.cover,
              )
                  : Container(),
              const SizedBox(height: 20),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text(getResultsButtonText ?? 'Get Results'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        child: Text(getResultsButtonText ?? 'Get Results'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        child: const Text('Translation'),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(10),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    GestureDetector(
                      onTap: () => _selectCategory('Lemon'),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/tomato.png',
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(lemonText ?? 'Lemon'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectCategory('Rose'),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/rose.png',
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(roseText ?? 'Rose'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectCategory('Marrygold'),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/marigold.png',
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(marrygoldText ?? 'Marrygold'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectCategory('Jasmin'),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/jasmin.png',
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(jasminText ?? 'Jasmin'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectCategory('Sunflower'),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/sunflower.png',
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(sunflowerText ?? 'Sunflower'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectCategory('LadyFinger'),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/ladyfinger.png',
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(ladyFingerText ?? 'LadyFinger'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectCategory(String category) {
    // Handle category selection
  }
}

