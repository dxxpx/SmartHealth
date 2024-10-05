#App Side
Here's an updated `README.md` for your Smart Health Application:

---

# Smart Health Application

## Overview
The Smart Health Application is designed to provide an integrated experience for managing home and healthcare needs within a smart environment. This application consists of four main sections: Admin, User, Doctor, and a Registration page. Each user role offers different functionalities to enhance the health and home experience.

## Features

### 1. Registration Page
- A user-friendly registration form for new users to sign up and gain access to the application features.

### 2. Admin Screen
The Admin section allows efficient management of the smart health environment:
- **View Feedback**: Admins can view feedback provided by users regarding their experiences and suggestions for improvement.
- **Add Announcements**: Admins can add important announcements that are visible to all users.
- **Add Floor Plan**: Admins can upload and manage floor plans for easy navigation by users.

### 3. User Screen
The User section offers a wide range of functionalities to enhance their smart health and home experience:
- **View Floor Plan**: Users can view the uploaded floor plan to understand the layout of their environment and navigate between different rooms.
- **Control HVAC Settings**: Users can control HVAC (Heating, Ventilation, and Air Conditioning) settings for different rooms to maintain a comfortable environment.
- **Community Engagement**: Users can interact with the community through the app, fostering a supportive atmosphere for discussions and activities.Users will also receive alerts if there is any disease outbreak in their area.
- **Chat with Doctor**: Users can chat with available doctors to discuss health-related questions.
- **Appointments**: Users can schedule appointments with doctors for consultations.
- **Provide Feedback**: Users can provide feedback about their experiences with the smart health application.
- **View Announcements**: Users can stay updated with the latest information by viewing announcements made by the admin.

### 4. Doctor Screen
The Doctor section provides specific functionalities for effective healthcare management:
- **Chat Screen**: Doctors can communicate with users through a chat feature to address their health-related queries.
- **View Active Appointments**: Doctors can view all upcoming appointments with users, allowing them to manage their schedules efficiently.

## Technology Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Node.js (Express)
- **Database**: Firebase (for real-time database, authentication, and storage)
- **Real-time Communication**: Firebase Realtime Database (used for chat functionality)
- **Blynk Cloud**: For real-time IoT data management and integration
- **Intel OneAPI**: To leverage optimized libraries and tools for efficient performance

## Installation
1. **Clone the Repository**:
   ```sh
   git clone https://github.com/your-repository/smart-health-app.git
   ```
2. **Navigate to Project Directory**:
   ```sh
   cd smart-health-app
   ```
3. **Install Dependencies**:
   - For Flutter Frontend:
     ```sh
     flutter pub get
     ```
   - For Node.js Backend:
     ```sh
     cd backend
     npm install
     ```
4. **Set Up Firebase**:
   - Configure your Firebase project.
   - Add the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) files to the appropriate directories.
   - Update the Firebase configuration in your Flutter project as needed.

5. **Run the Application**:
   - **Frontend**:
     ```sh
     flutter run
     ```
   - **Backend**:
     ```sh
     node server.js
     ```

## Usage
1. **Registration**: New users must register through the registration page to create an account.
2. **Login**: Users can log in to their respective roles (Admin, User, or Doctor) to access various functionalities.
3. **Admin Functions**: Add announcements, view user feedback, and manage the floor plan.
4. **User Functions**: Control HVAC settings, navigate the floor plan, chat with doctors, book appointments, provide feedback, and view announcements.
5. **Doctor Functions**: Manage appointments and communicate with users through chat.


## Future Enhancements
- **Voice Control Integration**: Adding voice control for managing HVAC settings.
- **Video Consultations**: Integrating video calls for doctor appointments.


# IoT - AI

For IntelGenAI  Hackathon

This project aims to make the best use of IoT data using a flutter built app. It is used

1) To monitor and control building parameters from the admin side with help of IoT

2) Runs various ML models on input data for uses like predictive maintenance of machines, prediction of water quality and potability based on parameters of the water, solar power output prediction, fire recognition from live video feed, sign language detection from live video feed and facial recognition for intrusion detection

3) The users are able to see the value of environmental factors they are exposed to and are able to get recommmendations from Gemini AI for their health tailored with their personal health data just like Gemini gives admins building recommendations

4) The users can anonymous send feedbacks to admins and are also able to connect to doctors while their account willbe groupeed based on their physical location



