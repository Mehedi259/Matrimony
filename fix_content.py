import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    if 'GetSnackBar' not in content:
        return

    # Find all occurrences of GetSnackBar( ... )
    # This might span multiple lines, so we use a regex or a simple stack to parse.
    # Since dart code is typically formatted predictably, we can just replace 'content:' with 'messageText:' 
    # if it's within a few lines after GetSnackBar, or we can use a small state machine.
    
    lines = content.split('\n')
    new_lines = []
    in_get_snackbar = 0
    
    for line in lines:
        if 'GetSnackBar(' in line:
            in_get_snackbar += 1
            
        if in_get_snackbar > 0:
            # We are inside GetSnackBar arguments
            if 'content:' in line:
                line = line.replace('content:', 'messageText:')
            
            # keep track of parentheses
            in_get_snackbar += line.count('(') - (1 if 'GetSnackBar(' in line else 0)
            in_get_snackbar -= line.count(')')
            
            if in_get_snackbar < 0: 
                in_get_snackbar = 0
                
        new_lines.append(line)
        
    new_content = '\n'.join(new_lines)
    
    # Let's also check if duration is provided. Default GetSnackBar duration is not like SnackBar?
    # Actually, GetSnackBar needs a duration. The default duration is 3 seconds, which is fine.
    
    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Fixed {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

