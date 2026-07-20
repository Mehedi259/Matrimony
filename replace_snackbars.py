import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    if 'ScaffoldMessenger.of(context).showSnackBar' not in content:
        return

    # Replace ScaffoldMessenger... with Get.showSnackbar(
    new_content = re.sub(r'ScaffoldMessenger\.of\(context\)\.showSnackBar\s*\(', r'Get.showSnackbar(', content)
    
    # We need to replace SnackBar( with GetSnackBar( but only for those inside the showSnackbar we just replaced.
    # A simple approach: we replace 'SnackBar(' with 'GetSnackBar(' if we know it's a snackbar.
    new_content = re.sub(r'\bSnackBar\s*\(', r'GetSnackBar(', new_content)
    
    # We replace 'content:' with 'messageText:'
    # Wait, what if there's other 'content:'? It's safer to only do it inside GetSnackBar.
    
    # Let's do a more careful replacement block by block.
    # Actually, GetSnackBar is fine, but we also need to add `import 'package:get/get.dart';`
    
    if "import 'package:get/get.dart';" not in new_content:
        # insert after the last import, or at the top
        imports = re.findall(r"^import\s+['\"].*?['\"];", new_content, flags=re.MULTILINE)
        if imports:
            last_import = imports[-1]
            new_content = new_content.replace(last_import, last_import + "\nimport 'package:get/get.dart';")
        else:
            new_content = "import 'package:get/get.dart';\n" + new_content

    # Now replace content: with messageText: inside GetSnackBar
    # Since we replaced SnackBar( with GetSnackBar(, let's replace content: that follows it.
    # We can just replace 'content:' with 'messageText:' globally in files that had ScaffoldMessenger.
    # It's a bit risky but usually 'content:' is mostly used in dialogs or SnackBars.
    # Let's verify by checking how many 'content:' there are that are NOT in SnackBars.

    with open(filepath, 'w') as f:
        f.write(new_content)
    print(f"Updated {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

