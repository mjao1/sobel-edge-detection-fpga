from PIL import Image

img = Image.open('image.png').convert('L')
img = img.resize((640, 480))
pixels = list(img.getdata())

with open('image.mem', 'w') as f:
    for pixel in pixels:
        f.write('{:02X}\n'.format(pixel))

