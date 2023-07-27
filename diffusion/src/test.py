import torch
from diffusers import StableDiffusionPipeline, DPMSolverMultistepScheduler

from torch import autocast

device = "cuda"

pipe = StableDiffusionPipeline.from_pretrained(
	"CompVis/stable-diffusion-v1-4", 
	use_auth_token="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"
).to(device)

from fastapi import FastAPI, Request
import shutil
import os
from fastapi.responses import FileResponse
import socket
from pydantic import BaseModel

import os
from fastapi import FastAPI
from PIL import Image
import glob

app = FastAPI()

class Prompt(BaseModel):
    prompt: str

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)
print("ip_address : ", ip_address)

@app.get('/diffusion/health')
async def hi():
    return {"response": "server running"}

@app.post('/diffusion/infer')
async def imageGen(request: Request, prompt: Prompt):

    out_path = 'result_images/*'

    # deleting result images
    for path in glob.glob(out_path):
        if os.path.exists(path):
            os.remove(path)

    folder_path = './result_images'

    prompt_text = prompt.prompt

    with autocast(device):
        image = pipe(prompt).images[0]

    # Save the image with the given prompt as the filename
    image_path = os.path.join(folder_path, f'{prompt_text}.png')
    image.save(image_path)

    return FileResponse(image_path)
