import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js' as js;



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isFullscreen = false;
  bool _showMenu = false;
  bool _isLoading = false;
  String imageUrl = '';

  
  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
   
    if (_isFullscreen) {
      html.document.documentElement?.requestFullscreen();
    } else {
      html.document.exitFullscreen();
    }
  }

 
  void _loadImage() {
    final url = _urlController.text;
    if (url.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      setState(() {
        imageUrl = url;
        _isLoading = false;
      });
    }
  }

 
  void _showContextMenu() {
    setState(() {
      _showMenu = true;
    });
  }

  void _hideContextMenu() {
    setState(() {
      _showMenu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Loader')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                     child: imageUrl.isNotEmpty
    ? HtmlElementView(viewType: 'image-container')
    : const Center(child: Text('No Image Loaded')),

                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _urlController,
                        decoration: const InputDecoration(hintText: 'Enter Image URL'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _loadImage,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
          if (_showMenu)
            GestureDetector(
              onTap: _hideContextMenu,
              child: Container(
                color: Colors.black54,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          if (_showMenu)
            Positioned(
              bottom: 80,
              right: 16,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _toggleFullscreen();
                      _hideContextMenu();
                    },
                    child: const Text('Enter Fullscreen'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _toggleFullscreen();
                      _hideContextMenu();
                    },
                    child: const Text('Exit Fullscreen'),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showContextMenu,
        child: const Icon(Icons.add),
      ),
    );
  }
}


void registerWebViewFactory() {
  html.document.registerElement('image-container', () {
    final img = html.ImageElement();
    img.style.width = '100%';
    img.style.height = '100%';
    img.style.objectFit = 'contain';
    img.src = ''; 
    img.onClick.listen((event) {
      js.context.callMethod('toggleFullscreen');
    });
    return img;
  });
}


extension on html.HtmlDocument {
  void registerElement(String s, html.ImageElement Function() param1) {}
}


void initializeWeb() {
  registerWebViewFactory();
}


