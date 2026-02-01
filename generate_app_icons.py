from PIL import Image, ImageDraw
import os

def create_base_icon(size=1024):
    """Create the B1 icon at specified size"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    center = size // 2
    radius = int(size * 0.43)
    
    # Gradient circle background
    for r in range(radius, 0, -1):
        ratio = r / radius
        color = (
            int(99 + (168 - 99) * ratio),
            int(102 + (85 - 102) * ratio),
            int(241 + (247 - 241) * ratio),
            255
        )
        draw.ellipse([center-r, center-r, center+r, center+r], fill=color)
    
    # Scale dots to icon size
    scale = size / 512
    base_dots = [(180, 150), (320, 180), (380, 280), (280, 350), (150, 300), (200, 220)]
    dots = [(int(x * scale), int(y * scale)) for x, y in base_dots]
    
    dot_color = (255, 255, 255)
    line_alpha = 150
    
    # Connect dots with glowing lines
    for glow in range(int(8 * scale), 0, -2):
        for i in range(len(dots)-1):
            draw.line([dots[i], dots[i+1]], fill=(*dot_color, int(line_alpha/3)), width=int(3*scale)+glow)
    
    for i in range(len(dots)-1):
        draw.line([dots[i], dots[i+1]], fill=(*dot_color, line_alpha), width=max(1, int(3*scale)))
    
    # Draw dots with glow
    dot_radius = max(2, int(10 * scale))
    glow_radius = max(4, int(20 * scale))
    
    for x, y in dots:
        for g in range(glow_radius, 0, -2):
            alpha = int(60 - g * 3 / scale) if scale > 0.5 else 30
            if alpha > 0:
                draw.ellipse([x-g, y-g, x+g, y+g], fill=(*dot_color, alpha))
        draw.ellipse([x-dot_radius, y-dot_radius, x+dot_radius, y+dot_radius], fill=(*dot_color, 255))
    
    return img

# iOS icon sizes
ios_sizes = {
    "Icon-App-1024x1024@1x.png": 1024,
    "Icon-App-60x60@3x.png": 180,
    "Icon-App-60x60@2x.png": 120,
    "Icon-App-76x76@2x.png": 152,
    "Icon-App-76x76@1x.png": 76,
    "Icon-App-83.5x83.5@2x.png": 167,
    "Icon-App-40x40@3x.png": 120,
    "Icon-App-40x40@2x.png": 80,
    "Icon-App-40x40@1x.png": 40,
    "Icon-App-29x29@3x.png": 87,
    "Icon-App-29x29@2x.png": 58,
    "Icon-App-29x29@1x.png": 29,
    "Icon-App-20x20@3x.png": 60,
    "Icon-App-20x20@2x.png": 40,
    "Icon-App-20x20@1x.png": 20,
}

# Android icon sizes
android_sizes = {
    "mipmap-xxxhdpi": 192,
    "mipmap-xxhdpi": 144,
    "mipmap-xhdpi": 96,
    "mipmap-hdpi": 72,
    "mipmap-mdpi": 48,
}

# Generate base icon
print("Generating base icon...")
base_icon = create_base_icon(1024)

# iOS
ios_dir = "C:/Users/joman/develop/trace_memories/ios/Runner/Assets.xcassets/AppIcon.appiconset"
os.makedirs(ios_dir, exist_ok=True)

print("Generating iOS icons...")
for filename, size in ios_sizes.items():
    icon = base_icon.resize((size, size), Image.Resampling.LANCZOS)
    # iOS needs no transparency, fill with background
    bg = Image.new('RGB', (size, size), (99, 102, 241))
    bg.paste(icon, mask=icon.split()[3] if icon.mode == 'RGBA' else None)
    bg.save(f"{ios_dir}/{filename}")
    print(f"  Created: {filename} ({size}x{size})")

# Android
android_base = "C:/Users/joman/develop/trace_memories/android/app/src/main/res"
print("Generating Android icons...")
for folder, size in android_sizes.items():
    folder_path = f"{android_base}/{folder}"
    os.makedirs(folder_path, exist_ok=True)
    icon = base_icon.resize((size, size), Image.Resampling.LANCZOS)
    # Save as PNG with transparency
    icon.save(f"{folder_path}/ic_launcher.png")
    # Also save foreground for adaptive icons
    icon.save(f"{folder_path}/ic_launcher_foreground.png")
    print(f"  Created: {folder}/ic_launcher.png ({size}x{size})")

# Play Store icon (512x512)
playstore_icon = base_icon.resize((512, 512), Image.Resampling.LANCZOS)
playstore_icon.save("C:/Users/joman/develop/trace_memories/icon_drafts/playstore_icon.png")
print("  Created: playstore_icon.png (512x512)")

print("\nDone! All icons generated.")
