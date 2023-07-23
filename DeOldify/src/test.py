#NOTE:  This must be the first call in order to work properly!
from deoldify import device
from deoldify.device_id import DeviceId
#choices:  CPU, GPU0...GPU7
device.set(device=DeviceId.GPU0)

from deoldify.visualize import *
plt.style.use('dark_background')
torch.backends.cudnn.benchmark=True
import warnings
warnings.filterwarnings("ignore", category=UserWarning, message=".*?Your .*? set is empty.*?")

colorizer = get_image_colorizer(artistic=True)

from fastapi import FastAPI, UploadFile, File
import shutil
import os
from fastapi.responses import FileResponse
import socket
import glob

app = FastAPI()

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)
print("ip_address : ", ip_address)

@app.get('/deoldify/health')
async def hi():
    return {"response": "server running"}

@app.post('/deoldify/infer')
async def deoldify(file: UploadFile = File(...)):

    source_folder = 'source_images/*'
    out_folder = 'result_images/*'

    # deleting result images
    for path in glob.glob(source_folder):
        if os.path.exists(path):
            os.remove(path)

    # deleting result images
    for path in glob.glob(out_folder):
        if os.path.exists(path):
            os.remove(path)

    save_directory = "./source_images"
    
    # Save the uploaded file
    file_path = os.path.join(save_directory, file.filename)
    with open(file_path, "wb") as image:
        shutil.copyfileobj(file.file, image)
        print("image written")

    #NOTE:  Max is 45 with 11GB video cards. 35 is a good default
    render_factor=35

    source_path = file_path
    result_path = colorizer.plot_transformed_image(path=source_path, render_factor=render_factor, compare=True)

    return FileResponse(result_path)
