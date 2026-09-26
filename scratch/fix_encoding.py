import sys
import shutil
sys.stdout.reconfigure(encoding='utf-8')

# Restore from backup and redo with Windows-1255 reverse mapping
shutil.copy2('chapter_9.html.bak2', 'chapter_9.html')
print("Restored from backup")

# Read the file
with open('chapter_9.html', 'rb') as f:
    data = f.read()

content = data.decode('utf-8')

# Find the garbled section boundaries  
str_start = content.find('id="questions-repo"')
str_end = content.find('id="questions-modal"')
str_start = content.rfind('\n', 0, str_start) + 1

before = content[:str_start]
garbled = content[str_start:str_end]
after = content[str_end:]

print(f"Section: {len(before)} + {len(garbled)} + {len(after)} chars")

# Build Windows-1255 reverse mapping: Unicode code point -> original byte value
win1255_reverse = {}
for byte_val in range(256):
    try:
        char = bytes([byte_val]).decode('cp1255')
        cp = ord(char)
        # Don't overwrite if already mapped (prefer lower byte values)
        if cp not in win1255_reverse:
            win1255_reverse[cp] = byte_val
    except:
        pass

# Debug: show key differences from CP1252
print("\nKey Win-1255 reverse mappings:")
print(f"  × (U+00D7) -> byte 0x{win1255_reverse.get(0x00D7, -1):02X}")  # Should be 0xAA
print(f"  ₪ (U+20AA) -> byte 0x{win1255_reverse.get(0x20AA, -1):02X}")  # Should be 0xA4
print(f"  ÷ (U+00F7) -> byte 0x{win1255_reverse.get(0x00F7, -1):02X}")  # Should be 0xBA

# PHASE 1: Fix geresh-prefixed garbled Hebrew characters
# Pattern: U+05F3 (geresh) + char -> D7 + win1255_reverse(char)
fixed_chars = []
chars = list(garbled)
i = 0
fix_count = 0
unfixed_geresh = []

while i < len(chars):
    if chars[i] == '\u05F3' and i + 1 < len(chars):
        next_cp = ord(chars[i + 1])
        
        # Get the original byte value via Win-1255 reverse mapping
        original_byte = None
        if next_cp in win1255_reverse:
            original_byte = win1255_reverse[next_cp]
        elif next_cp <= 0xFF:
            original_byte = next_cp
        
        if original_byte is not None and 0x80 <= original_byte <= 0xBF:
            # Valid continuation byte -> reconstruct D7 + byte as UTF-8
            try:
                hebrew_char = bytes([0xD7, original_byte]).decode('utf-8')
                fixed_chars.append(hebrew_char)
                fix_count += 1
                i += 2
                continue
            except UnicodeDecodeError:
                pass
        
        # Try as D6 prefix (niqqud range)
        if original_byte is not None and 0x80 <= original_byte <= 0xBF:
            try:
                hebrew_char = bytes([0xD6, original_byte]).decode('utf-8')
                fixed_chars.append(hebrew_char)
                fix_count += 1
                i += 2
                continue
            except:
                pass
        
        unfixed_geresh.append((i, f"U+{next_cp:04X}", original_byte))
        fixed_chars.append(chars[i])
        i += 1
    else:
        fixed_chars.append(chars[i])
        i += 1

phase1_text = ''.join(fixed_chars)
print(f"\nPhase 1: Fixed {fix_count} geresh-prefixed chars")
if unfixed_geresh:
    print(f"  Unfixed: {len(unfixed_geresh)}")
    for pos, cp, byte in unfixed_geresh[:10]:
        print(f"    [{pos}] {cp} byte=0x{byte:02X}" if byte else f"    [{pos}] {cp} no mapping")

# PHASE 2: Fix multi-byte garbled characters (like ג€" → —)
# These are UTF-8 multi-byte sequences where each byte was re-encoded through Win-1255
# Pattern: Win1255(byte1) + Win1255(byte2) + ... → original multi-byte UTF-8 char
#
# Hebrew chars ג,ד,ה etc. (Win-1255 bytes E2,E3,E4) appear as first "byte" 
# of 3-byte UTF-8 sequences (E2 XX XX, E3 XX XX, etc.)
#
# Also: נ (Win-1255 byte F0) appears as first byte of 4-byte sequences (F0 XX XX XX)

# Build forward mapping too: byte -> Win-1255 char
win1255_forward = {}
for byte_val in range(256):
    try:
        char = bytes([byte_val]).decode('cp1255')
        win1255_forward[byte_val] = char
    except:
        pass

# Strategy: scan for Hebrew characters that could be garbled multi-byte sequences
# A Hebrew char (from Win-1255 E0-FA range) followed by non-Hebrew chars could be a garbled sequence
import re

def try_ungarble_sequence(text, pos):
    """Try to reconstruct a multi-byte UTF-8 char from Win-1255-garbled sequence starting at pos."""
    if pos >= len(text):
        return None, 0
    
    ch = text[pos]
    cp = ord(ch)
    
    # Get the Win-1255 byte for this character
    if cp not in win1255_reverse:
        return None, 0
    
    first_byte = win1255_reverse[cp]
    
    # Determine expected sequence length from first byte
    if 0xC0 <= first_byte <= 0xDF:
        seq_len = 2
    elif 0xE0 <= first_byte <= 0xEF:
        seq_len = 3
    elif 0xF0 <= first_byte <= 0xF7:
        seq_len = 4
    else:
        return None, 0
    
    # Try to collect the remaining bytes
    raw_bytes = bytearray([first_byte])
    chars_consumed = 1
    
    for j in range(1, seq_len):
        if pos + chars_consumed >= len(text):
            return None, 0
        next_ch = text[pos + chars_consumed]
        next_cp = ord(next_ch)
        
        if next_cp in win1255_reverse:
            next_byte = win1255_reverse[next_cp]
            # Continuation bytes must be 0x80-0xBF
            if 0x80 <= next_byte <= 0xBF:
                raw_bytes.append(next_byte)
                chars_consumed += 1
            else:
                return None, 0
        elif next_cp <= 0xFF:
            next_byte = next_cp
            if 0x80 <= next_byte <= 0xBF:
                raw_bytes.append(next_byte)
                chars_consumed += 1
            else:
                return None, 0
        else:
            return None, 0
    
    # Try to decode
    try:
        decoded = bytes(raw_bytes).decode('utf-8')
        return decoded, chars_consumed
    except:
        return None, 0

# Phase 2: Fix ג€" and similar patterns
# We need to be careful not to touch legitimate Hebrew characters!
# Only fix sequences where a Hebrew char (from E0-FA Win-1255 range) is followed
# by characters that together form a valid multi-byte UTF-8 sequence

# Win-1255 bytes E0-FA map to Hebrew chars א-ת
# These same bytes (E0-EF) are also first bytes of 3-byte UTF-8 sequences
# And F0-F4 are first bytes of 4-byte UTF-8 sequences

# To distinguish garbled sequences from real Hebrew:
# A garbled 3-byte sequence looks like: ג€" (Hebrew + non-Hebrew + non-Hebrew)
# A real Hebrew char is just ג followed by normal text
# The key: the chars after the Hebrew char must also be garbled (Win-1255 interpretations of 0x80-0xBF)

# Chars that represent Win-1255 bytes 0x80-0xBF:
continuation_chars = set()
for byte_val in range(0x80, 0xC0):
    if byte_val in win1255_forward:
        continuation_chars.add(win1255_forward[byte_val])

# Hebrew chars that map to first bytes of multi-byte sequences (E0-EF for 3-byte, F0-F4 for 4-byte)
multibyte_first_chars = {}
for byte_val in range(0xE0, 0xF5):  # E0-F4
    if byte_val in win1255_forward:
        multibyte_first_chars[win1255_forward[byte_val]] = byte_val

print(f"\nMulti-byte first chars mapping:")
for ch, bv in sorted(multibyte_first_chars.items(), key=lambda x: x[1]):
    print(f"  {ch} (U+{ord(ch):04X}) -> byte 0x{bv:02X}")

# Also handle 2-byte sequences starting with C0-DF
for byte_val in range(0xC0, 0xE0):
    if byte_val in win1255_forward:
        ch = win1255_forward[byte_val]
        if ch not in multibyte_first_chars:
            multibyte_first_chars[ch] = byte_val

# Now scan the phase1 text for potential garbled multi-byte sequences
fixed_chars2 = []
i = 0
phase2_fixes = 0
text = phase1_text

while i < len(text):
    ch = text[i]
    
    if ch in multibyte_first_chars:
        # This could be a garbled multi-byte UTF-8 sequence
        # But it could also be a legitimate Hebrew character!
        # Check if the following chars look like continuation bytes
        
        first_byte = multibyte_first_chars[ch]
        
        if 0xE0 <= first_byte <= 0xEF:
            # 3-byte sequence: need 2 continuation chars
            result, consumed = try_ungarble_sequence(text, i)
            if result and consumed == 3:
                # Verify the result makes sense (is a real Unicode char, not garbage)
                result_cp = ord(result)
                # Common ranges: punctuation, symbols, emojis, mathematical
                if (0x2000 <= result_cp <= 0x2BFF or  # General punctuation, symbols
                    0x2E00 <= result_cp <= 0x2E7F or  # Supplemental punctuation
                    0xFE00 <= result_cp <= 0xFFFF or  # Specials
                    0x0300 <= result_cp <= 0x036F or  # Combining diacriticals
                    result_cp >= 0x10000):             # Supplementary (emojis etc.)
                    fixed_chars2.append(result)
                    phase2_fixes += 1
                    i += consumed
                    continue
                # Also check for specific known garbled patterns
                elif result in '—–""''•…†‡‰‹›€™▼▶▲◀►◄↓↑←→↔↕∑∏∐√∞≈≠≤≥±×÷':
                    fixed_chars2.append(result)
                    phase2_fixes += 1
                    i += consumed
                    continue
        
        elif 0xF0 <= first_byte <= 0xF4:
            # 4-byte sequence: need 3 continuation chars
            result, consumed = try_ungarble_sequence(text, i)
            if result and consumed == 4:
                fixed_chars2.append(result)
                phase2_fixes += 1
                i += consumed
                continue
    
    fixed_chars2.append(ch)
    i += 1

final_text = ''.join(fixed_chars2)
print(f"\nPhase 2: Fixed {phase2_fixes} multi-byte garbled sequences")

# Also fix 2-byte garbled sequences from C2/C3 range  
# These look like: Win1255(C2)=² or Win1255(C3)=³ followed by continuation
# Actually C2 and C3 aren't in the Hebrew range of Win-1255
# Win-1255 C0-C9 are mapped to specific chars:
# C0=À, C1=Á, C2=Â, C3=Ã, C4=Ä, C5=Å, C6=Æ, C7=Ç, C8=È, C9=É
# These are Latin chars, unlikely to appear naturally in Hebrew text
# But they might be garbled 2-byte UTF-8 sequences

# For now, let's also handle ג–¼ → ▼ pattern
# ג = E2, – (U+2013, Win-1255 byte 96), ¼ (U+00BC, Latin-1 byte BC)
# E2 96 BC = ▼ ✓

# Write the result
output = before + final_text + after
with open('chapter_9.html', 'w', encoding='utf-8') as f:
    f.write(output)

print("\nFile written!")

# Verification
with open('chapter_9.html', 'r', encoding='utf-8') as f:
    verify = f.read()

q_section = verify[verify.find('id="questions-repo"'):verify.find('id="questions-modal"')]

# Count remaining issues
remaining_geresh = q_section.count('\u05F3')
remaining_garbled = 0
for ch in continuation_chars:
    # Count non-Hebrew chars that might indicate remaining garbling
    pass

print(f"Remaining geresh: {remaining_geresh}")

# Show sample
title_idx = q_section.find('data-title="') + len('data-title="')
title_end = q_section.find('">', title_idx)
print(f"Sample title: {q_section[title_idx:title_end]}")

# Show a question sample
q_idx = q_section.find('class="q-item-box')
if q_idx != -1:
    span_idx = q_section.find('<span>', q_idx) + len('<span>')
    span_end = q_section.find('</span>', span_idx)
    print(f"Sample question: {q_section[span_idx:span_end][:200]}")

# Show more samples to check quality
for marker in ['strong>תשובה', 'strong>שאל', 'Protection Domain']:
    idx = q_section.find(marker)
    if idx != -1:
        start = max(0, idx - 20)
        end = min(len(q_section), idx + 100)
        print(f"Context '{marker}': ...{q_section[start:end]}...")
