import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String patientId;
  final String patientName;

  ChatPage({
    required this.doctorId,
    required this.doctorName,
    required this.patientId,
    required this.patientName,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty || _images.isNotEmpty) {
      // Create message data with images if any
      Map<String, dynamic> messageData = {
        'text': _messageController.text,
        'images': _images.map((img) => img.path).toList(),
        'userName': widget.doctorName,
        'userId': widget.doctorId,
        'timestamp': FieldValue.serverTimestamp(),
      };

      try {
        // Store the message in Firestore
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(widget.doctorId)
            .collection('patients')
            .doc(widget.patientId)
            .collection('messages')
            .add(messageData);

        // Optionally, update last message in the patient's document
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(widget.doctorId)
            .collection('patients')
            .doc(widget.patientId)
            .update({'lastMessage': _messageController.text});

        _messageController.clear();
        _images.clear(); // Reset images list
        setState(() {});
      } catch (e) {
        print("Error sending message: $e");
      }
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _images.addAll(selectedImages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.patientName}'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('doctors')
                  .doc(widget.doctorId)
                  .collection('patients')
                  .doc(widget.patientId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child:
                          Text('Error fetching messages: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final isUserMessage = message['userId'] == widget.doctorId;

                    return Align(
                      alignment: isUserMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.teal[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: isUserMessage
                                ? Radius.circular(16)
                                : Radius.zero,
                            bottomRight: isUserMessage
                                ? Radius.zero
                                : Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['userName'] ?? 'Unknown',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                            SizedBox(height: 5),
                            if (message['text'] != null &&
                                message['text'].isNotEmpty)
                              Text(
                                message['text'],
                                style: TextStyle(fontSize: 16),
                              ),
                            if (message['images'] != null &&
                                (message['images'] as List).isNotEmpty) ...[
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                children: (message['images'] as List<dynamic>)
                                    .map<Widget>((image) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(image),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.photo, color: Colors.teal),
                  onPressed: _pickImages,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
