from PIL import Image, ImageDraw, ImageFilter, ImageFont
import math
import os

output_dir = "C:/Users/joman/develop/trace_memories/icon_drafts"
os.makedirs(output_dir, exist_ok=True)

def create_icon_a():
    """Dark with glowing pin + route"""
    size = 512
    img = Image.new('RGBA', (size, size), (15, 23, 42, 255))
    draw = ImageDraw.Draw(img)
    
    # Glowing route curve
    for glow in range(20, 0, -2):
        alpha = int(50 - glow * 2)
        for i in range(100):
            t = i / 100
            x = 100 + t * 312 + math.sin(t * 3.14 * 2) * 50
            y = 400 - t * 250
            draw.ellipse([x-glow, y-glow, x+glow, y+glow], fill=(56, 189, 248, alpha))
    
    # Main route
    points = []
    for i in range(100):
        t = i / 100
        x = 100 + t * 312 + math.sin(t * 3.14 * 2) * 50
        y = 400 - t * 250
        points.append((x, y))
    draw.line(points, fill=(56, 189, 248, 255), width=6)
    
    # Pin at end
    pin_x, pin_y = 350, 150
    # Pin glow
    for g in range(30, 0, -3):
        draw.ellipse([pin_x-g, pin_y-g, pin_x+g, pin_y+g], fill=(248, 113, 113, int(30-g)))
    # Pin body
    draw.ellipse([pin_x-25, pin_y-25, pin_x+25, pin_y+25], fill=(248, 113, 113, 255))
    draw.ellipse([pin_x-10, pin_y-10, pin_x+10, pin_y+10], fill=(255, 255, 255, 255))
    
    img.save(f"{output_dir}/icon_a_dark_route.png")
    return f"{output_dir}/icon_a_dark_route.png"

def create_icon_b():
    """Gradient circle with abstract memory dots"""
    size = 512
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Gradient circle background
    for r in range(220, 0, -1):
        ratio = r / 220
        color = (
            int(99 + (168 - 99) * ratio),
            int(102 + (85 - 102) * ratio),
            int(241 + (247 - 241) * ratio),
            255
        )
        draw.ellipse([256-r, 256-r, 256+r, 256+r], fill=color)
    
    # Memory dots (like constellation)
    dots = [(180, 150), (320, 180), (380, 280), (280, 350), (150, 300), (200, 220)]
    # Connect dots
    for i in range(len(dots)-1):
        draw.line([dots[i], dots[i+1]], fill=(255, 255, 255, 150), width=3)
    # Draw dots
    for x, y in dots:
        draw.ellipse([x-12, y-12, x+12, y+12], fill=(255, 255, 255, 255))
    
    img.save(f"{output_dir}/icon_b_gradient_dots.png")
    return f"{output_dir}/icon_b_gradient_dots.png"

def create_icon_c():
    """Minimal dark with glowing T letter"""
    size = 512
    img = Image.new('RGBA', (size, size), (15, 23, 42, 255))
    draw = ImageDraw.Draw(img)
    
    # Outer ring glow
    for g in range(40, 0, -2):
        alpha = int(40 - g)
        draw.ellipse([50-g, 50-g, 462+g, 462+g], outline=(56, 189, 248, alpha), width=2)
    
    # Ring
    draw.ellipse([50, 50, 462, 462], outline=(56, 189, 248, 200), width=4)
    
    # T + pin shape in center
    # Vertical line of T
    draw.rounded_rectangle([230, 150, 282, 400], radius=10, fill=(248, 250, 252, 255))
    # Horizontal line of T
    draw.rounded_rectangle([150, 150, 362, 200], radius=10, fill=(248, 250, 252, 255))
    # Small pin dot
    draw.ellipse([236, 340, 276, 380], fill=(248, 113, 113, 255))
    
    img.save(f"{output_dir}/icon_c_minimal_t.png")
    return f"{output_dir}/icon_c_minimal_t.png"

# Generate all icons
print("Generating icons...")
a = create_icon_a()
print(f"Created: {a}")
b = create_icon_b()
print(f"Created: {b}")
c = create_icon_c()
print(f"Created: {c}")
print("Done!")
