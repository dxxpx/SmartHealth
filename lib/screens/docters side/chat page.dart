// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class ChatPage extends StatefulWidget {
//   final String doctorId;
//   final String doctorName;
//
//   ChatPage({required this.doctorId, required this.doctorName});
//
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   final User? currentUser = FirebaseAuth.instance.currentUser;
//   List<XFile> _images = [];
//   String? _userName;
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserName();
//   }
//
//   Future<void> _getUserName() async {
//     try {
//       if (currentUser != null) {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(currentUser!.uid)
//             .get();
//         if (userDoc.exists) {
//           setState(() {
//             _userName = userDoc['name'] ?? 'Unknown';
//           });
//         } else {
//           setState(() {
//             _userName = 'Unknown';
//           });
//         }
//       }
//     } catch (e) {
//       print('Error fetching username: $e');
//       setState(() {
//         _userName = 'Unknown';
//       });
//     }
//   }
//
//   Future<void> _sendMessage() async {
//     if (_messageController.text.isNotEmpty || _images.isNotEmpty) {
//       // Create a message map
//       Map<String, dynamic> messageData = {
//         'text': _messageController.text,
//         'images': _images.map((img) => img.path).toList(),
//         'userName': _userName,
//         'userId': currentUser?.uid,
//         'timestamp': FieldValue.serverTimestamp(),
//       };
//
//       // Add the message to the Firestore collection specific to the doctor and patient user
//       await FirebaseFirestore.instance
//           .collection('doctors')
//           .doc(widget.doctorId)
//           .collection('users')
//           .doc(currentUser!.uid)
//           .collection('messages')
//           .add(messageData);
//
//       _messageController.clear();
//       _images.clear(); // Reset images list
//       setState(() {});
//     }
//   }
//
//   Future<void> _pickImages() async {
//     try {
//       final List<XFile>? selectedImages = await _picker.pickMultiImage();
//       if (selectedImages != null) {
//         setState(() {
//           _images = selectedImages;
//         });
//       }
//     } catch (e) {
//       print('Error picking images: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with Dr. ${widget.doctorName}'),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('doctors')
//                   .doc(widget.doctorId)
//                   .collection('users')
//                   .doc(currentUser!.uid)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error fetching messages'));
//                 }
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 final messages = snapshot.data!.docs;
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message =
//                         messages[index].data() as Map<String, dynamic>;
//                     final isUserMessage = message['userName'] == _userName;
//
//                     return Align(
//                       alignment: isUserMessage
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Container(
//                         margin:
//                             EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isUserMessage
//                               ? Colors.teal[100]
//                               : Colors.grey[200],
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(16),
//                             topRight: Radius.circular(16),
//                             bottomLeft: isUserMessage
//                                 ? Radius.circular(16)
//                                 : Radius.zero,
//                             bottomRight: isUserMessage
//                                 ? Radius.zero
//                                 : Radius.circular(16),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               message['userName'] ?? 'Unknown',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.teal[800]),
//                             ),
//                             SizedBox(height: 5),
//                             if (message['text'] != null &&
//                                 message['text'].isNotEmpty)
//                               Text(
//                                 message['text'],
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             if (message['images'] != null &&
//                                 (message['images'] as List).isNotEmpty) ...[
//                               SizedBox(height: 10),
//                               Wrap(
//                                 spacing: 8,
//                                 children: (message['images'] as List<dynamic>)
//                                     .map<Widget>((image) {
//                                   return ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Image.file(
//                                       File(image),
//                                       width: 100,
//                                       height: 100,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.photo, color: Colors.teal),
//                   onPressed: _pickImages,
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: InputDecoration(
//                         hintText: 'Type your message...',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.teal),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  ChatPage({required this.doctorId, required this.doctorName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<XFile> _images = [];
  String? _userName;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    try {
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            _userName = userDoc['name'] ?? 'Unknown';
          });
        } else {
          setState(() {
            _userName = 'Unknown';
          });
        }
      }
    } catch (e) {
      print('Error fetching username: $e');
      setState(() {
        _userName = 'Unknown';
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty || _images.isNotEmpty) {
      // Create a message map
      Map<String, dynamic> messageData = {
        'text': _messageController.text,
        'images': _images.map((img) => img.path).toList(),
        'userName': _userName,
        'userId': currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add the message to the Firestore collection specific to the doctor and patient user
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(widget.doctorId)
          .collection('users')
          .doc(currentUser!.uid)
          .collection('messages')
          .add(messageData);

      _messageController.clear();
      _images.clear(); // Reset images list
      setState(() {});
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null) {
        setState(() {
          _images = selectedImages;
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Dr. ${widget.doctorName}'),
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
                  .collection('users')
                  .doc(currentUser!.uid)
                  .collection('messages')
                  .orderBy('timestamp', descending: true) // Chronological order
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching messages'));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final isUserMessage = message['userName'] == _userName;

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
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
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
