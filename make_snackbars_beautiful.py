import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    if 'GetSnackBar(' not in content:
        return

    # Add snackPosition: SnackPosition.TOP, margin: const EdgeInsets.all(16), borderRadius: 8,
    # just after GetSnackBar(
    
    # We will use regex to find 'GetSnackBar(' and replace it with:
    # GetSnackBar(snackPosition: SnackPosition.TOP, margin: const EdgeInsets.all(16), borderRadius: 8,
    
    new_content = re.sub(r'\bGetSnackBar\s*\(', r'GetSnackBar(\n          snackPosition: SnackPosition.TOP,\n          margin: const EdgeInsets.all(16),\n          borderRadius: 8,', content)
    
    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Beautified {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

