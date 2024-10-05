
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
- **Community Engagement**: Users can interact with the community through the app, fostering a supportive atmosphere for discussions and activities.
- **Chat with Doctor**: Users can chat with available doctors to discuss health-related questions.
- **Appointments**: Users can schedule appointments with doctors for consultations.
- **Provide Feedback**: Users can provide feedback about their experiences with the smart health application.
- **View Announcements**: Users can stay updated with the latest information by viewing announcements made by the admin.

### 4. Doctor Screen
The Doctor section provides specific functionalities for effective healthcare management:
- **Chat Screen**: Doctors can communicate with users through a chat feature to address their health-related queries.
- **View Active Appointments**: Doctors can view all upcoming appointments with users, allowing them to manage their schedules efficiently.

### 5. Notification System
Integrated using Django to provide real-time notifications to users:
- **Real-time Alerts**: Users receive notifications for important updates, appointment reminders, and community events.
- **Admin Notifications**: Admins can send targeted notifications to specific user groups as needed.

### 6. IoT Data Management
Leveraging Blynk Cloud for seamless integration and management of IoT devices:
- **Real-time IoT Data**: Manage and monitor IoT devices within the smart home environment.
- **Device Integration**: Easily integrate various IoT devices for enhanced home automation and health monitoring.

### 7. Performance Optimization
Utilizing Intel OneAPI to enhance application performance:
- **Optimized Libraries**: Leverage Intel OneAPI’s optimized libraries for computational tasks.
- **Efficient Performance**: Improve the efficiency and speed of the application through advanced performance tools.

## Technology Stack
- **Frontend**: Flutter (Dart)
- **Backend**:
  - **Node.js** (Express) for core backend services
  - **Django** for the notification system
- **Database**: Firebase (for real-time database, authentication, and storage)
- **Real-time Communication**: Firebase Realtime Database (used for chat functionality)
- **IoT Data Management**: Blynk Cloud for real-time IoT data management and integration
- **Performance Optimization**: Intel OneAPI to leverage optimized libraries and tools for efficient performance

## Installation
Follow the steps below to set up the Smart Health Application on your local machine.

### 1. Clone the Repository
```sh
git clone https://github.com/your-repository/smart-health-app.git
```

### 2. Navigate to Project Directory
```sh
cd smart-health-app
```

### 3. Install Dependencies

#### For Flutter Frontend:
```sh
flutter pub get
```

#### For Node.js Backend:
```sh
cd backend/node-server
npm install
```

#### For Django Notification System:
```sh
cd ../flutterAlerts
pip install -r requirements.txt
```
*Ensure you have Python and `pip` installed on your system.*

#### For Intel OneAPI:
1. **Download Intel OneAPI Toolkit**:
   - Visit the [Intel OneAPI Toolkit](https://software.intel.com/content/www/us/en/develop/tools/oneapi.html) page.
   - Download the appropriate version for your operating system.

2. **Install Intel OneAPI**:
   - Follow the installation instructions provided on the Intel website.
   - After installation, ensure that the environment variables are set correctly. You can typically do this by sourcing the `setvars.sh` script:
     ```sh
     source /opt/intel/oneapi/setvars.sh
     ```

### 4. Set Up Firebase
- Configure your Firebase project.
- Add the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) files to the appropriate directories.
- Update the Firebase configuration in your Flutter project as needed.

### 5. Configure Environment Variables
Ensure that both the Node.js and Django applications have the necessary environment variables set. You can create `.env` files in their respective directories based on the provided `.env.example` templates.

### 6. Run the Applications

#### Start the Node.js Backend Server:
```sh
cd ../node-server
node server.js
```

#### Start the Django Notification Server:
Open a new terminal window/tab and navigate to the Django directory:
```sh
cd backend/django
python manage.py runserver
```

#### Run the Flutter Frontend:
Open another terminal window/tab and navigate to the project root:
```sh
cd ../../
flutter run
```

*Ensure that the Node.js server, Django server, and Intel OneAPI are properly configured and running concurrently to enable full functionality.*

## Usage
1. **Registration**: New users must register through the registration page to create an account.
2. **Login**: Users can log in to their respective roles (Admin, User, or Doctor) to access various functionalities.
3. **Admin Functions**: Add announcements, view user feedback, and manage the floor plan.
4. **User Functions**: Control HVAC settings, navigate the floor plan, chat with doctors, book appointments, provide feedback, and view announcements.
5. **Doctor Functions**: Manage appointments and communicate with users through chat.
6. **Notifications**: Receive real-time notifications for updates, appointments, and community events.
7. **IoT Management**: Monitor and control IoT devices within the smart home environment through Blynk Cloud.
8. **Performance**: Experience optimized performance powered by Intel OneAPI.

## Screenshots
(Add screenshots of the application screens if available)

## Future Enhancements
- **Voice Control Integration**: Adding voice control for managing HVAC settings.
- **Video Consultations**: Integrating video calls for doctor appointments.
- **Advanced IoT Integrations**: Expanding IoT device compatibility and functionalities.
- **Enhanced Performance Features**: Further leveraging Intel OneAPI for additional performance optimizations.


### Additional Notes

- **Django Integration**: The Django application handles the notification system, enabling real-time alerts and updates to users. Ensure that the Django server is running alongside the Node.js server to facilitate seamless communication between the frontend and backend services.

- **Blynk Cloud Integration**: Blynk Cloud manages IoT devices, providing real-time data and control capabilities. Properly configure your IoT devices and ensure they are connected to the Blynk project for optimal functionality.

- **Intel OneAPI Setup**: Intel OneAPI enhances application performance through optimized libraries and tools. After installation, ensure that the environment variables are correctly set and that your development environment is configured to utilize OneAPI features.

- **Environment Setup**: It is recommended to use virtual environments for Python dependencies to avoid conflicts. You can create a virtual environment using:
  ```sh
  python -m venv venv
  source venv/bin/activate  # On Windows: venv\Scripts\activate
  ```

- **Database Migrations**: After setting up Django, apply migrations to set up the necessary database tables:
  ```sh
  python manage.py migrate
  ```

- **Static Files**: Collect static files for Django if necessary:
  ```sh
  python manage.py collectstatic
  ```

- **Testing**: Ensure all services are running correctly by testing each functionality, including user registration, login, chat features, appointment scheduling, notifications, IoT device management, and performance optimizations.


# IoT - AI

For IntelGenAI  Hackathon

This project aims to make the best use of IoT data using a flutter built app. It is used

1) To monitor and control building parameters from the admin side with help of IoT

2) Runs various ML models on input data for uses like predictive maintenance of machines, prediction of water quality and potability based on parameters of the water, solar power output prediction, fire recognition from live video feed, sign language detection from live video feed and facial recognition for intrusion detection

3) The users are able to see the value of environmental factors they are exposed to and are able to get recommmendations from Gemini AI for their health tailored with their personal health data just like Gemini gives admins building recommendations

4) The users can anonymous send feedbacks to admins and are also able to connect to doctors while their account willbe groupeed based on their physical location



