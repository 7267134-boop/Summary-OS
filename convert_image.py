import base64
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
image_path = os.path.join(script_dir, "Gemini_Generated_Image_.png")

with open(image_path, "rb") as f:
    image_data = f.read()

base64_str = base64.b64encode(image_data).decode("ascii")
print(f"Base64 length: {len(base64_str)}")

output_path = os.path.join(script_dir, "image_base64.txt")
with open(output_path, "w") as f:
    f.write(base64_str)

print(f"Saved to: {output_path}")
