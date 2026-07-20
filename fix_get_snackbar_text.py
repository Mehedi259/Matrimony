import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    if 'GetSnackBar' not in content:
        return

    lines = content.split('\n')
    new_lines = []
    changed = False
    
    for line in lines:
        if 'messageText: Text(' in line and 'DefaultTextStyle' not in line:
            # We want to wrap Text(...) with DefaultTextStyle
            # Let's see if the line ends with '),'
            if line.endswith(','):
                line = line.replace('messageText: Text(', 'messageText: DefaultTextStyle(style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500), child: Text(') + '),'
            else:
                line = line.replace('messageText: Text(', 'messageText: DefaultTextStyle(style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500), child: Text(') + ')'
            changed = True
        new_lines.append(line)

    if changed:
        new_content = '\n'.join(new_lines)
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Fixed text color {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

