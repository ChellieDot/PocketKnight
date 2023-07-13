# POCKET KNIGHT
This repository is for a Swift-Application that H. Hartmann and M. Wilken developed as part of the "Mobile Computing" course for the Media Computer Science Bachelors Programme at the Bremen City University of Applied Sciences.


## Getting Started
To test this application on either a real device or a simulated iPhone, this repository should be cloned and opened in Xcode.
Development was done in Xcode Version 14.3.1, but older versions should be compatible as well, as long as it supports iOS development from at least 15.0


### Configuration
+ It is recommended to test the application on a simulated iPhone 14 (iPhone 12 was tested as well, but not as thoroughly).
  To do so, select the desired target device in the top middle of your Xcode Project window.
+ To test the application on a real iPhone, please make sure that you have a Apple ID connected to Xcode (Xcode -> Settings -> Accounts)
  Afterwards, connect your iPhone to the MacOS device via USB and select the iPhone as a target device (as previously described)
  Building the application will install the App on the connected iPhone.

**The iPhone might prevent you from accessing the app. To allow usage anyway go to "Settings -> General -> VPN and Devices" on your iPhone and allow / trust apps from your Apple ID**


### Live Preview and Simulation
Inside the Project, inside Views -> ContentView.swift is a configured Live Preview. This can be used to navigate through the application. But: any changes to the source code will result in a refresh of the live demo.
The preview will always load in portrait mode. Since the application is built to be viewed in landscape (and will only do so on a real device), please click on "Device Settings" in the Preview Area and Toggle "Orientation" before proceeding with the preview.
</br>
To open the app on a simulated device, simply press the "Build" Button (similar to "Play") in the top left of your project window, after selecting a target device as previously mentioned.


### Constraints
+ Starting the application for the first time will prompt a Health-Usage request to the user. This prompt forces the applications orientation to portrait mode and overrides the apps constraints. Please accept the Health-Usage request and simply restart the app.
+ Naturally, simulated devices (regardless of live preview or Simulator-App), do not have actual Health Data to get access to. By default the application will then return a Queried stepCount of 0
  </br> (As seen in "Manager -> HealthStore.swift -> Line 66).
  This return statement can be used to manipulate the data to test the applications functionality.
  - keep the alternative value of 0 and start any kind of adventure.
  - change the return value in line 66 to any desired "stepCount"
  - finishing the adventure now will take the second value and use it as its "finished stepCount" to determine the difference between both values.


## Architecture
- Pocket Knight
  - Manager
    - All Manager-Classes are resposible for handling the applications logic.
      StartupManager fetches data during the start of the application to feed data into the DataManager
      DataManager holds every data that is needed for the UI. Values can be changed during runtime and will be kept up-to-date by this class
      AdventureManager handles commuication to either the HealthStore or the database and handles every other bit of logic
  - Data-Persistence
    - holds the DBStore that manages the applications SQLite3 database
    - JSONLoader parses .json data into pre-defined object structures
    - .json-files pre-define items for the application
  - Models
    - Custom defined Object structures that are important for the Manager and Persistence classes are found here
  - Views / Subviews
    - ContentView: ContentView is the first view that gets called when the application starts.
      This view handles the defined EnvironmentObjects, determines which View is currently displayed and it contains the Live-Preview configuration.
    - Every other View contains UI-Elements to navigate through the application
    - Subviews are additions to the other views and are layered on top of those.


## External Packages

Although most of the application is built using the built-in features and technologies from Apple themselves, such as the HealthKit or originally planned the Multipeer Connectivity Framework, one additional Package is used in this project.
The Data persistence was implemented using "SQLite.Swift".
</br>
SQLite.Swift is a Swift language layer over SQLite3. For more detailed information, please see commentary in DBStore.swift or visit https://github.com/stephencelis/SQLite.swift
