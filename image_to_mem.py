from PIL import Image

img = Image.open('image3.png').convert('L')
img = img.resize((960, 540))
pixels = list(img.getdata())

with open('image3.mem', 'w') as f:
    for pixel in pixels:
        f.write('{:02X}\n'.format(pixel))
