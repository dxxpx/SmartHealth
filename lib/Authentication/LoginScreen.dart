import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthealth/screens/adminSide/adminHome.dart';
import '../screens/userside/homepage.dart';
import '../screens/userside/floor_plan_rooms/floor_plan.dart';
import 'package:smarthealth/services/BlynkService.dart';
import 'package:smarthealth/screens/docters side/docters_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "", regEmail = "";
  String password = "", regPassword = "";
  String deptID = "";
  String name = "";

  @override
  void initState() {
    super.initState();
    BlynkService("eGTiuLVeg2GRGqbN1YdVib6ByTvjBA_V").writePin("v4", "1");
  }

  final TextEditingController adminEmailController =
      TextEditingController(text: "dxpka@gmail.com");
  final TextEditingController adminPasswordController =
      TextEditingController(text: "123456");

  final TextEditingController emailController =
      TextEditingController(text: "deepika@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "123456");

  final TextEditingController doctorEmailController =
      TextEditingController(text: "amruthabj09@gmail.com");
  final TextEditingController doctorPasswordController =
      TextEditingController(text: "teddybear2309");

  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final TextEditingController deptIDController = TextEditingController();

  Future<void> _signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Navigate to the home screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid Login')));
    }
  }

  Future<void> _adminSignIn() async {
    try {
      if (adminEmailController.text == "dxpka@gmail.com" &&
          adminPasswordController.text == "123456") {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmailController.text,
          password: adminPasswordController.text,
        );

        // Navigate to the admin home screen after successful login
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => adminHomePage()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Login')));
      }
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid Login')));
    }
  }

  Future<void> _doctorSignIn() async {
    try {
      if (doctorEmailController.text == "amruthabj09@gmail.com" &&
          doctorPasswordController.text == "teddybear2309") {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: doctorEmailController.text,
          password: doctorPasswordController.text,
        );

        // Navigate to the doctor's home screen after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorHomePage(
              doctorId: userCredential.user!.uid,
              doctorName: "Dr. Amrutha",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Login')));
      }
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid Login')));
    }
  }

  Future<void> _registerUser() async {
    try {
      // Register the user with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: registerEmailController.text,
        password: registerPasswordController.text,
      );

      // Save user details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': registerEmailController.text,
        'name': nameController.text,
        'deptid': deptIDController.text,
        'uid': userCredential.user!.uid,
        'fcmtoken': ''
      });

      // Navigate to home screen after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      // Handle registration errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // User Login Section
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('User Login'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            Divider(),
            const SizedBox(height: 20),

            // Admin Login Section
            Text(
              'Admin Login',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: adminEmailController,
              decoration: InputDecoration(
                labelText: 'Admin Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: adminPasswordController,
              decoration: InputDecoration(
                labelText: 'Admin Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _adminSignIn,
              child: const Text('Admin Login'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            Divider(),
            const SizedBox(height: 20),

            // Doctor Login Section
            Text(
              'Doctor Login',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: doctorEmailController,
              decoration: InputDecoration(
                labelText: 'Doctor Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: doctorPasswordController,
              decoration: InputDecoration(
                labelText: 'Doctor Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _doctorSignIn,
              child: const Text('Doctor Login'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            Divider(),
            const SizedBox(height: 20),

            // Register Section
            Text(
              'Register',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Enter Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              controller: nameController,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Enter Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              controller: registerEmailController,
              onChanged: (value) {
                setState(() {
                  regEmail = value;
                });
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Enter Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              controller: registerPasswordController,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  regPassword = value;
                });
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Enter Dept ID",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              controller: deptIDController,
              onChanged: (value) {
                setState(() {
                  deptID = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text('Register'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
