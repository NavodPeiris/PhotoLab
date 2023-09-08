# PhotoLab
This is Cloud Computing project 2 which is a mobile app that can perform
   - image super resolution
   - image colorization
   - style transfer
   - image generation

mobile application upload the images and text to services running on AWS Cloud. In AWS cloud we are running an ECS cluster with autoscaling for each service.

app directory contain Flutter app.

1. cd into app directory and run **flutter pub get** to install dependencies.

2. connect a android device and run **flutter run android** to build app in device.

