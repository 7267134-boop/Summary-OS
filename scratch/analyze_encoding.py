import sys
import os
sys.stdout.reconfigure(encoding='utf-8')

# Read the file as raw bytes
with open('chapter_9.html', 'rb') as f:
    data = f.read()

# Find the start of questions-repo
marker = b'id="questions-repo"'
pos = data.find(marker)
print(f"questions-repo found at byte offset: {pos}")

# Find end of questions-repo (last closing div before the modal)
end_marker = b'<!-- /questions-repo -->'
end_pos = data.find(end_marker, pos)
if end_pos == -1:
    # Try to find the questions-modal as end boundary
    end_marker2 = b'id="questions-modal"'
    end_pos = data.find(end_marker2, pos)
    print(f"Using questions-modal as boundary at: {end_pos}")
else:
    print(f"questions-repo end at: {end_pos}")

# Look at a garbled sample
title_start = data.find(b'data-title="', pos) + len(b'data-title="')
title_end = data.find(b'">', title_start)
garbled_sample = data[title_start:title_end]
print(f"\nGarbled title bytes (first 80): {garbled_sample[:80].hex(' ')}")

# Analyze the byte pattern
# D7 B3 C2 A9 = geresh + ©
# D7 B3 C2 90 = geresh + <control>
# D7 B3 C2 9C = geresh + <control>
# D7 B3 E2 80 A2 = geresh + •
# D7 B3 C3 97 = geresh + ×

# The pattern is clear: D7 B3 is always followed by a multi-byte UTF-8 char
# Let's try the standard double-encoding fix:
# Read the garbled UTF-8 text, re-encode as Latin-1 to recover the intermediate bytes,
# then decode those bytes as UTF-8

# But wait - D7 B3 can't be encoded as Latin-1 because B3 > 7F with D7 prefix
# means it's the UTF-8 encoding of U+05F3 which is > 0xFF, so Latin-1 can't represent it.

# Let me look at this differently. 
# What if the original bytes were Hebrew UTF-8 (D7 A9 for 'ש'),
# and each of the TWO bytes got independently re-encoded through CP1252->UTF-8?
# D7 in CP1252 = × (U+00D7) -> UTF-8: C3 97
# A9 in CP1252 = © (U+00A9) -> UTF-8: C2 A9
# So 'ש' (D7 A9) becomes C3 97 C2 A9 = "×©"
# But we're seeing D7 B3 C2 A9, not C3 97 C2 A9...

# Hmm, D7 B3... what if D7 is kept as-is but paired with B3?
# And the actual second byte (A9) becomes C2 A9?
# So the pattern might be: D7 B3 replaces D7, and C2 A9 encodes A9
# This would mean: to fix it, skip D7 B3 -> use D7, and decode the following char back to its byte value

# Let's verify: 
# Original 'ש' = D7 A9
# Garbled: D7 B3 C2 A9
# -> D7 (first byte of original) + B3 (always the same?) + C2 A9 (UTF-8 of 0xA9 = second byte)
# So the fix: replace D7 B3 + UTF-8(X) -> D7 + X

# Test this theory:
print("\n--- Testing fix theory ---")
text = garbled_sample.decode('utf-8')
print(f"Unicode text length: {len(text)}")

# The fix: find every U+05F3 (geresh), take the next character's code point as the second byte,
# combine with D7 to form the original Hebrew character
fixed_bytes = bytearray()
i = 0
chars = list(text)
while i < len(chars):
    if chars[i] == '\u05F3' and i + 1 < len(chars):
        # This is a garbled Hebrew char
        next_char = chars[i + 1]
        second_byte = ord(next_char)
        if second_byte <= 0xFF:
            # Reconstruct: D7 + second_byte
            fixed_bytes.append(0xD7)
            fixed_bytes.append(second_byte)
            i += 2
        else:
            # Multi-byte, need to handle differently
            fixed_bytes.extend(chars[i].encode('utf-8'))
            i += 1
    else:
        fixed_bytes.extend(chars[i].encode('utf-8'))
        i += 1

try:
    fixed_text = fixed_bytes.decode('utf-8')
    print(f"Fixed text: {fixed_text}")
except Exception as e:
    print(f"Fix failed with UTF-8: {e}")
    # Try some bytes as hex
    print(f"Fixed bytes: {bytes(fixed_bytes).hex(' ')}")

# Let's also look at what chars follow the geresh in the original
print("\n--- Char analysis ---")
for i, ch in enumerate(chars[:40]):
    cp = ord(ch)
    if cp > 127:
        print(f"  [{i}] U+{cp:04X} ({ch})", end="")
        if ch == '\u05F3':
            if i+1 < len(chars):
                next_cp = ord(chars[i+1])
                print(f" -> next: U+{next_cp:04X} ({chars[i+1]})", end="")
                # If this is paired, what Hebrew char would D7+next_cp be?
                if next_cp <= 0xFF:
                    try:
                        hebrew_char = bytes([0xD7, next_cp]).decode('utf-8')
                        print(f" -> Hebrew: {hebrew_char} (U+{ord(hebrew_char):04X})")
                    except:
                        print(f" -> D7 {next_cp:02X} is not valid UTF-8")
                else:
                    print()
            else:
                print()
        else:
            print()
