import base64
import os

# Get the image file path
script_dir = r"c:\Users\72671\Desktop\20594 - מערכות הפעלה\סיכום"
image_path = os.path.join(script_dir, "Gemini_Generated_Image_.png")

with open(image_path, "rb") as f:
    image_data = f.read()

base64_str = base64.b64encode(image_data).decode("ascii")
print(f"Base64 length: {len(base64_str)}")

# Write the base64 to the workspace
output_path = os.path.join(script_dir, "image_base64.txt")
with open(output_path, "w") as f:
    f.write(base64_str)

print("Done!")
