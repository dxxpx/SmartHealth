import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat page.dart'; // Ensure you have this page implemented
import 'appointment_page.dart'; // Ensure you have this page implemented for booking appointments

class DoctorListItem extends StatelessWidget {
  final DocumentSnapshot doctor;

  DoctorListItem({required this.doctor});

  @override
  Widget build(BuildContext context) {
    String name = doctor.get('name') ?? 'No Name';
    String specialty = doctor.get('specialty') ?? 'No Specialty';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.medical_services),
        ),
        title: Text(name),
        subtitle: Text(specialty),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'chat') {
              // Navigate directly to the ChatPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    doctorId: doctor.id,
                    doctorName: name,
                  ),
                ),
              );
            } else if (value == 'video_call') {
              // Navigate directly to the AppointmentPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentPage(
                    doctorId: doctor.id,
                    doctorName: name,
                  ),
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'chat',
              child: ListTile(
                leading: Icon(Icons.chat),
                title: Text('Chat with us'),
              ),
            ),
            PopupMenuItem<String>(
              value: 'video_call',
              child: ListTile(
                leading: Icon(Icons.video_call),
                title: Text('Book a Video Call Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
