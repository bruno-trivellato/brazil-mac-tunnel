#!/usr/bin/env python3

from PIL import Image, ImageDraw, ImageFont
import os

# Create a 1024x1024 image for the icon
size = 1024
img = Image.new('RGB', (size, size), color='white')
draw = ImageDraw.Draw(img)

# Brazil flag colors
green = '#009639'
yellow = '#FEDD00'
blue = '#002776'

# Draw Brazil flag
# Green background
draw.rectangle([0, 0, size, size], fill=green)

# Yellow diamond
diamond_points = [
    (size//2, size//6),      # top
    (5*size//6, size//2),    # right
    (size//2, 5*size//6),    # bottom
    (size//6, size//2)       # left
]
draw.polygon(diamond_points, fill=yellow)

# Blue circle
circle_center = size//2
circle_radius = size//6
draw.ellipse([
    circle_center - circle_radius,
    circle_center - circle_radius,
    circle_center + circle_radius,
    circle_center + circle_radius
], fill=blue)

# Add "SSH" text in white
try:
    # Try to use a system font
    font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 80)
except:
    font = ImageFont.load_default()

text = "SSH"
bbox = draw.textbbox((0, 0), text, font=font)
text_width = bbox[2] - bbox[0]
text_height = bbox[3] - bbox[1]
text_x = (size - text_width) // 2
text_y = (size - text_height) // 2

draw.text((text_x, text_y), text, fill='white', font=font)

# Save as PNG first
png_path = '/Users/bruno.trivellato/Desktop/Brazil SSH Tunnel.app/Contents/Resources/icon.png'
img.save(png_path, 'PNG')

print(f"✅ Created Brazil flag icon: {png_path}")
print("🇧🇷 Converting to .icns format...")

# Convert to .icns using sips (built-in macOS tool)
icns_path = '/Users/bruno.trivellato/Desktop/Brazil SSH Tunnel.app/Contents/Resources/icon.icns'
os.system(f'sips -s format icns "{png_path}" --out "{icns_path}"')
os.remove(png_path)

print("✅ Icon conversion complete!")