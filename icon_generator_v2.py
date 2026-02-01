from PIL import Image, ImageDraw, ImageFilter
import math
import os

output_dir = "C:/Users/joman/develop/trace_memories/icon_drafts"
os.makedirs(output_dir, exist_ok=True)

def create_icon_b_variant(variant_name, colors, dot_color=(255,255,255), line_alpha=150):
    """Create variations of the B concept"""
    size = 512
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Gradient circle background
    start_color, end_color = colors
    for r in range(220, 0, -1):
        ratio = r / 220
        color = (
            int(start_color[0] + (end_color[0] - start_color[0]) * ratio),
            int(start_color[1] + (end_color[1] - start_color[1]) * ratio),
            int(start_color[2] + (end_color[2] - start_color[2]) * ratio),
            255
        )
        draw.ellipse([256-r, 256-r, 256+r, 256+r], fill=color)
    
    # Memory dots (like constellation) - slightly randomized positions
    dots = [(180, 150), (320, 180), (380, 280), (280, 350), (150, 300), (200, 220)]
    
    # Connect dots with glowing lines
    for glow in range(8, 0, -2):
        for i in range(len(dots)-1):
            draw.line([dots[i], dots[i+1]], fill=(*dot_color, int(line_alpha/3)), width=3+glow)
    
    for i in range(len(dots)-1):
        draw.line([dots[i], dots[i+1]], fill=(*dot_color, line_alpha), width=3)
    
    # Draw dots with glow
    for x, y in dots:
        # Glow
        for g in range(20, 0, -2):
            alpha = int(60 - g * 3)
            draw.ellipse([x-g, y-g, x+g, y+g], fill=(*dot_color, alpha))
        # Core
        draw.ellipse([x-10, y-10, x+10, y+10], fill=(*dot_color, 255))
    
    path = f"{output_dir}/{variant_name}.png"
    img.save(path)
    return path

# Variant 1: Original purple-blue
v1 = create_icon_b_variant(
    "b1_purple_blue",
    colors=((99, 102, 241), (168, 85, 247))  # indigo to purple
)

# Variant 2: Cyan-blue (matches app's cyan accent)
v2 = create_icon_b_variant(
    "b2_cyan_blue",
    colors=((6, 182, 212), (59, 130, 246))  # cyan to blue
)

# Variant 3: Sunset (warm)
v3 = create_icon_b_variant(
    "b3_sunset",
    colors=((251, 146, 60), (239, 68, 68))  # orange to red
)

# Variant 4: Dark elegant (dark purple with gold dots)
v4 = create_icon_b_variant(
    "b4_dark_gold",
    colors=((30, 27, 75), (88, 28, 135)),  # very dark purple
    dot_color=(251, 191, 36),  # amber/gold
    line_alpha=180
)

print(f"Created: {v1}")
print(f"Created: {v2}")
print(f"Created: {v3}")
print(f"Created: {v4}")
print("Done!")
