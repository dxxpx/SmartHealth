import "package:firebase_messaging/firebase_messaging.dart";
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../userside/healthScreen1.dart';
import '../../services/LLM.dart';
import '../../screens/Sensorsdisplay.dart';
import 'package:smarthealth/models/Deviceselection.dart';
import 'package:smarthealth/screens/userSide/feedbackScreen.dart';
import 'package:smarthealth/screens/userSide/floor_plan_rooms/floor_plan.dart';
import 'package:smarthealth/screens/userSide/userAnnouncementsPage.dart';
import 'package:smarthealth/screens/userSide/user_request _page.dart';
import 'package:smarthealth/screens/docters side/view_nearby_docters.dart';
import 'package:smarthealth/screens/community/community page.dart';
import 'package:smarthealth/tools/UiComponents.dart';
import '../sensors/sensorUi.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<DeviceSelection> deviceSelections = [
    DeviceSelection(category: 'Home', selectedDevices: []),
    DeviceSelection(category: 'Office', selectedDevices: []),
    DeviceSelection(category: 'Garden', selectedDevices: []),
    DeviceSelection(category: 'Industry', selectedDevices: []),
  ];

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    try {
      messaging.subscribeToTopic('fire_alerts');
      print("Subscribed to FireAlerts");
    } catch (e) {
      print(e);
    }
    print("hello");
  }

  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => healthscreen1()));
        break;

      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LeaveRequestPage()));
        break;
      case 2:
        Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home - IQ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton<int>(
            color: Colors.white,
            onSelected: (item) => _onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Add Health metrics')),
              PopupMenuItem<int>(
                  value: 1, child: Text('Add Health metrics detailed')),
              PopupMenuItem<int>(value: 2, child: Text('Request permission')),
              PopupMenuItem<int>(value: 3, child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '!! ANNOUNCEMENTS !!',
                style: TextStyle(
                    color: Colors.teal.shade900, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('announcements')
                  .orderBy('timestamp', descending: true)
                  .limit(2)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return Center(child: Text('No announcements found.'));
                }
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!.docs.map((doc) {
                      return ListTile(
                        title: Text(doc['title']),
                        subtitle: Text(doc['content']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PreviousAnnouncementsScreen(),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            ElevatedButton(
                style: BtnStyle(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FloorPlanWidget()));
                },
                child: Text(
                  'Floor PLans',
                  style: buttonTstlye(),
                )),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 35.0),
            child: FloatingActionButton(
              child: Icon(Icons.chat),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatPage()));
              },
            ),
          ),
          FloatingActionButton(
            child: Icon(Icons.feedback),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserFeedbackScreen()));
            },
          ),
          FloatingActionButton(
            child: Icon(Icons.group), // Community icon
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AllDoctorsPage())); // Navigate to CommunityPage
            },
          ),
          FloatingActionButton(
            child: Icon(Icons.group), // Community icon
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QueryListPage())); // Navigate to CommunityPage
            },
          ),
        ],
      ),
    );
  }
}
