# PhotoLab
This is Cloud Computing project 2 which is a mobile app that can perform
   - image super resolution
   - image colorization
   - style transfer
   - image generation

mobile applications upload the images and text to services running on AWS Cloud. In AWS cloud we are running 4 ECS clusters with autoscaling for each service.

app directory contain Flutter app.

You have to download the models for super resolution and colorization

download model for super resolution by this url: https://drive.google.com/file/d/1TPrz5QKd8DHHt1k8SRtm6tMiPjz_Qene/view?usp=drive_link

download model for colorization by this url: https://data.deepai.org/deoldify/ColorizeArtistic_gen.pth

other 4 directories are inference APIs that should be hosted on AWS ECS clusters

1. cd into app directory and run **flutter pub get** to install dependencies.

2. connect a android device and run **flutter run android** to build app in device.

3. cd into superResolution and run the following commands:

   **python -m venv diffenv**
      - this will make the virtual environment inside the directory

   **pip install -r requirements.txt**
      - this will install the required packages

4. then build the docker image by running the following command:**

   **docker build -t superres .**
      - this will build the docker image

5. to create container from image, run the following command:

   **docker run -p 8000:8000 --name superres-api superres**


