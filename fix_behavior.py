import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    if 'SnackBarBehavior.floating' not in content and 'SnackBarBehavior.fixed' not in content:
        return

    # Replace behavior: SnackBarBehavior.floating, with empty string
    new_content = re.sub(r'behavior:\s*SnackBarBehavior\.floating\s*,?', '', content)
    new_content = re.sub(r'behavior:\s*SnackBarBehavior\.fixed\s*,?', '', new_content)
    
    # Sometimes it might not have the comma
    new_content = re.sub(r'behavior:\s*SnackBarBehavior\.floating', '', new_content)
    new_content = re.sub(r'behavior:\s*SnackBarBehavior\.fixed', '', new_content)

    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Fixed {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

