import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    if 'GetSnackBar' not in content:
        return

    # Add duration
    new_content = re.sub(
        r'borderRadius:\s*8,', 
        r'borderRadius: 8,\n          duration: const Duration(seconds: 3),', 
        content
    )
    
    # Improve colors and add icon
    new_content = re.sub(
        r'backgroundColor:\s*Colors\.green,?',
        r'backgroundColor: Colors.teal,\n          icon: const Icon(Icons.check_circle_outline, color: Colors.white),',
        new_content
    )
    new_content = re.sub(
        r'backgroundColor:\s*Colors\.red,?',
        r'backgroundColor: Colors.redAccent,\n          icon: const Icon(Icons.error_outline, color: Colors.white),',
        new_content
    )
    
    # Force Text color to white for messageText
    # Find messageText: Text( something ) and add style: const TextStyle(color: Colors.white)
    # We'll use a regex that finds messageText: Text( ... ) and injects the style.
    # Since Text() can have multiple arguments, we'll just insert style: const TextStyle(color: Colors.white), before the closing parenthesis if there isn't one already.
    # Actually, a simpler way is to replace 'messageText: Text(' with a wrapper or just use 'message: ' instead of 'messageText:'.
    # Wait! GetSnackBar has a 'message' property that takes a String! If we use 'message:', GetX automatically styles it white and uses the default font!
    # BUT we currently have messageText: Text('...').
    # Let's extract the string from Text(...) and use 'message: ...' instead.
    # Regex to match messageText: Text( <capture everything inside> )
    
    # This might be tricky because of nested parentheses.
    # Alternative: replace `messageText: Text(` with `messageText: DefaultTextStyle(style: const TextStyle(color: Colors.white), child: Text(`
    # But then we need to add a closing parenthesis.
    
    # Let's just do a regex replace on the Text widget content inside GetSnackBar.
    # We can replace 'messageText: Text(' with 'messageText: Text(' and inject style at the end? Hard.
    
    # Let's try to replace messageText: Text( "some string" ) with message: "some string"
    # Or messageText: Text( variables ) with message: (variables).toString()
    
    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Fixed {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

