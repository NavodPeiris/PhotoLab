# PhotoLab
This is Cloud Computing project 2

app directory contain Flutter app.

other 4 directories are inference APIs that should be hosted on AWS

go to superResolution/src and run the following command:

pip install -r requirements.txt
   - this will install the required packages

then build the docker image by running the following command:

docker build -t superres .
   - this will build the docker image

to run the docker image, run the following command:

docker run -p 8000:8000 --name superres-api superres


