// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter/material.dart';
// import 'package:smarthome/docters side/docter list page.dart';
//
// class NearbyDoctorsPage extends StatefulWidget {
//   @override
//   _NearbyDoctorsPageState createState() => _NearbyDoctorsPageState();
// }
//
// class _NearbyDoctorsPageState extends State<NearbyDoctorsPage> {
//   final Geoflutterfire geo = Geoflutterfire();
//   Stream<List<DocumentSnapshot>>? stream;
//   Position? userPosition;
//   bool isLoading = true;
//   final double searchRadius = 10.0; // in kilometers
//
//   @override
//   void initState() {
//     super.initState();
//     _initLocationAndQuery();
//   }
//
//   Future<void> _initLocationAndQuery() async {
//     await _getCurrentLocation();
//     if (userPosition != null) {
//       setState(() {
//         stream = getNearbyDoctors(
//             userPosition!.latitude, userPosition!.longitude, searchRadius);
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Unable to fetch location')),
//       );
//     }
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Location services are disabled.')),
//         );
//         return;
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Location permissions are denied')),
//           );
//           return;
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text('Location permissions are permanently denied')),
//         );
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       userPosition = position;
//     } catch (e) {
//       print("Error getting location: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error getting location: $e')),
//       );
//     }
//   }
//
//   Stream<List<DocumentSnapshot>> getNearbyDoctors(
//       double latitude, double longitude, double radiusInKm) {
//     GeoFirePoint center = geo.point(latitude: latitude, longitude: longitude);
//     return geo
//         .collection(
//             collectionRef: FirebaseFirestore.instance.collection('doctors'))
//         .within(
//           center: center,
//           radius: radiusInKm,
//           field: 'location.geopoint',
//           strictMode: true,
//         )
//         .map((List<DocumentSnapshot> documentList) => documentList);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Nearby Doctors'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : (stream == null
//               ? Center(child: Text('No location data available'))
//               : StreamBuilder<List<DocumentSnapshot>>(
//                   stream: stream,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasError) {
//                       return Center(child: Text('Error fetching doctors'));
//                     }
//                     if (!snapshot.hasData) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     List<DocumentSnapshot> doctors = snapshot.data!;
//                     if (doctors.isEmpty) {
//                       return Center(child: Text('No doctors found nearby'));
//                     }
//                     return ListView.builder(
//                       itemCount: doctors.length,
//                       itemBuilder: (context, index) {
//                         var doctor = doctors[index];
//                         return DoctorListItem(doctor: doctor);
//                       },
//                     );
//                   },
//                 )),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointment_page.dart';

class AllDoctorsPage extends StatefulWidget {
  @override
  _AllDoctorsPageState createState() => _AllDoctorsPageState();
}

class _AllDoctorsPageState extends State<AllDoctorsPage> {
  Stream<List<DocumentSnapshot>>? stream;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    stream = getAllDoctors();
  }

  Stream<List<DocumentSnapshot>> getAllDoctors() {
    return FirebaseFirestore.instance.collection('doctors').snapshots().map(
      (snapshot) {
        return snapshot.docs;
      },
    );
  }

  List<DocumentSnapshot> _filterDoctors(List<DocumentSnapshot> doctors) {
    if (searchQuery.isEmpty) {
      return doctors;
    }
    return doctors.where((doctor) {
      return doctor['name'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Doctors'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Doctors',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching doctors'));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<DocumentSnapshot> doctors = _filterDoctors(snapshot.data!);
                if (doctors.isEmpty) {
                  return Center(child: Text('No doctors found'));
                }

                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    var doctor = doctors[index];
                    String doctorName = doctor['name'] ?? 'No Name';
                    String specialty = doctor['specialty'] ?? 'No Specialty';

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.medical_services),
                        ),
                        title: Text(doctorName),
                        subtitle: Text(specialty),
                        trailing: IconButton(
                          icon:
                              Icon(Icons.document_scanner, color: Colors.teal),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentPage(
                                  doctorId: doctor.id,
                                  doctorName: doctorName,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
