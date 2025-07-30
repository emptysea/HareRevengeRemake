from PIL import Image
import numpy as np

def convert (target_color, data):
	# Create a mask for pixels matching the target color
	mask = (data[:, :, 0] == target_color[0]) & \
	(data[:, :, 1] == target_color[1]) & \
	(data[:, :, 2] == target_color[2])

	data[mask, 3] = 0

	return data
		
# Load your image
img = Image.open("turtle_sprite.png").convert("RGBA")

# Convert to NumPy array
data = np.array(img)

# Target color: RGB = (12, 12, 12)
target_colors = {
	(0x12, 0x11, 0x0c),
	(0x18, 0x0e, 0x0c),
	(0x0a, 0x0c, 0x07),
	(0x0d, 0x0b, 0x0c),
	(0x0d, 0x0c, 0x07),
	(0x0b, 0x0d, 0x0c),
	(0x0c, 0x0a, 0x0f),
	(0x08, 0x0c, 0x0b),
	(0x0c, 0x0a, 0x0b),
	(0x09, 0x10, 0x09),
	(0x0c, 0x0d, 0x11),
	(0x0c, 0x0f, 0x06),
	(0x0c, 0x0b, 0x10),
	(0x08, 0x08, 0x0a),
	(0x0d, 0x08, 0x0e)
}

for color in target_colors:
	data = convert (color, data)

# Convert back to image
img_transparent = Image.fromarray(data)

# Save the result
img_transparent.save("turtle_transparent.png")
