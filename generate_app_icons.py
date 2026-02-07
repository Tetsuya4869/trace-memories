import math
import os
from PIL import Image, ImageDraw


def create_base_icon(size=1024):
    """Simple trace icon: dark circle with a curved route and pin dot."""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    center = size // 2
    radius = int(size * 0.43)

    # Dark gradient circle (primaryDark #0F172A -> secondaryDark #1E293B)
    for r in range(radius, 0, -1):
        t = 1.0 - (r / radius)
        color = (
            int(15 + (30 - 15) * t),
            int(23 + (41 - 23) * t),
            int(42 + (59 - 42) * t),
            255,
        )
        draw.ellipse(
            [center - r, center - r, center + r, center + r], fill=color
        )

    s = size / 1024.0  # scale factor

    # --- Draw curved route path using bezier-like segments ---
    # Route goes from bottom-left to top-right in a smooth S-curve
    route_points = []
    steps = 200
    for i in range(steps + 1):
        t = i / steps
        # S-curve using cubic bezier:
        # P0=(280,700) P1=(200,400) P2=(750,550) P3=(700,280)
        u = 1 - t
        x = (u**3 * 280 + 3 * u**2 * t * 200 + 3 * u * t**2 * 750 + t**3 * 700) * s
        y = (u**3 * 700 + 3 * u**2 * t * 400 + 3 * u * t**2 * 550 + t**3 * 280) * s
        route_points.append((x, y))

    # Draw route as overlapping circles for smooth anti-aliased result
    # Glow pass
    glow_r = int(16 * s)
    for x, y in route_points[::2]:
        draw.ellipse([x - glow_r, y - glow_r, x + glow_r, y + glow_r],
                     fill=(56, 189, 248, 12))

    # Main route (solid circles along path)
    route_r = int(5 * s)
    for x, y in route_points:
        draw.ellipse([x - route_r, y - route_r, x + route_r, y + route_r],
                     fill=(56, 189, 248, 255))

    # --- Small start dot ---
    sx, sy = route_points[0]
    start_r = int(12 * s)
    draw.ellipse(
        [sx - start_r, sy - start_r, sx + start_r, sy + start_r],
        fill=(56, 189, 248, 120),
    )

    # --- Pin at end of route ---
    ex, ey = route_points[-1]

    # Pin glow (accentPurple #818CF8)
    for g in range(int(40 * s), 0, -2):
        a = max(3, int(40 - g))
        draw.ellipse(
            [ex - g, ey - g, ex + g, ey + g], fill=(129, 140, 248, a)
        )

    # Pin outer circle (purple)
    pin_r = int(22 * s)
    draw.ellipse(
        [ex - pin_r, ey - pin_r, ex + pin_r, ey + pin_r],
        fill=(129, 140, 248, 255),
    )

    # Pin inner circle (white)
    inner_r = int(10 * s)
    draw.ellipse(
        [ex - inner_r, ey - inner_r, ex + inner_r, ey + inner_r],
        fill=(255, 255, 255, 255),
    )

    return img


# --- Platform sizes ---

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

android_sizes = {
    "mipmap-xxxhdpi": 192,
    "mipmap-xxhdpi": 144,
    "mipmap-xhdpi": 96,
    "mipmap-hdpi": 72,
    "mipmap-mdpi": 48,
}

macOS_sizes = {
    "app_icon_16.png": 16,
    "app_icon_32.png": 32,
    "app_icon_64.png": 64,
    "app_icon_128.png": 128,
    "app_icon_256.png": 256,
    "app_icon_512.png": 512,
    "app_icon_1024.png": 1024,
}

BASE = "/home/user/trace-memories"

print("Generating 1024x1024 base icon...")
base_icon = create_base_icon(1024)

# Save draft
draft_dir = f"{BASE}/icon_drafts"
os.makedirs(draft_dir, exist_ok=True)
base_icon.save(f"{draft_dir}/simple_trace.png")
print(f"  Draft saved: icon_drafts/simple_trace.png")

# iOS (no transparency)
ios_dir = f"{BASE}/ios/Runner/Assets.xcassets/AppIcon.appiconset"
os.makedirs(ios_dir, exist_ok=True)
print("Generating iOS icons...")
for filename, sz in ios_sizes.items():
    icon = base_icon.resize((sz, sz), Image.Resampling.LANCZOS)
    bg = Image.new("RGB", (sz, sz), (15, 23, 42))
    bg.paste(icon, mask=icon.split()[3])
    bg.save(f"{ios_dir}/{filename}")
    print(f"  {filename} ({sz}x{sz})")

# Android (with transparency)
android_base = f"{BASE}/android/app/src/main/res"
print("Generating Android icons...")
for folder, sz in android_sizes.items():
    folder_path = f"{android_base}/{folder}"
    os.makedirs(folder_path, exist_ok=True)
    icon = base_icon.resize((sz, sz), Image.Resampling.LANCZOS)
    icon.save(f"{folder_path}/ic_launcher.png")
    icon.save(f"{folder_path}/ic_launcher_foreground.png")
    print(f"  {folder}/ic_launcher.png ({sz}x{sz})")

# macOS
macos_dir = f"{BASE}/macos/Runner/Assets.xcassets/AppIcon.appiconset"
os.makedirs(macos_dir, exist_ok=True)
print("Generating macOS icons...")
for filename, sz in macOS_sizes.items():
    icon = base_icon.resize((sz, sz), Image.Resampling.LANCZOS)
    bg = Image.new("RGB", (sz, sz), (15, 23, 42))
    bg.paste(icon, mask=icon.split()[3])
    bg.save(f"{macos_dir}/{filename}")
    print(f"  {filename} ({sz}x{sz})")

# Web
web_dir = f"{BASE}/web"
icons_dir = f"{web_dir}/icons"
os.makedirs(icons_dir, exist_ok=True)
print("Generating Web icons...")

for sz, name in [(16, "favicon.png"), (192, "icons/Icon-192.png"), (512, "icons/Icon-512.png")]:
    icon = base_icon.resize((sz, sz), Image.Resampling.LANCZOS)
    bg = Image.new("RGB", (sz, sz), (15, 23, 42))
    bg.paste(icon, mask=icon.split()[3])
    bg.save(f"{web_dir}/{name}")
    print(f"  {name} ({sz}x{sz})")

for sz, name in [(192, "icons/Icon-maskable-192.png"), (512, "icons/Icon-maskable-512.png")]:
    icon = base_icon.resize((sz, sz), Image.Resampling.LANCZOS)
    icon.save(f"{web_dir}/{name}")
    print(f"  {name} ({sz}x{sz})")

# Play Store
playstore = base_icon.resize((512, 512), Image.Resampling.LANCZOS)
bg = Image.new("RGB", (512, 512), (15, 23, 42))
bg.paste(playstore, mask=playstore.split()[3])
bg.save(f"{draft_dir}/playstore_icon.png")
print("  playstore_icon.png (512x512)")

print("\nDone!")
