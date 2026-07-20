import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    if 'ScaffoldMessenger.of(context).showSnackBar' not in content:
        return

    # 1. Replace ScaffoldMessenger... with Get.showSnackbar(
    new_content = re.sub(r'ScaffoldMessenger\.of\(context\)\.showSnackBar\s*\(', r'Get.showSnackbar(', content)
    
    # 2. Replace SnackBar( with GetSnackBar(
    new_content = re.sub(r'\bSnackBar\s*\(', r'GetSnackBar(', new_content)
    
    # 3. Replace content: Text( ... ) with messageText: Text( ... , style: ... )
    # Since regex is risky with nested parens, let's just do:
    # Instead of Text styling, let's just add snackPosition, margin, duration, etc.
    # We will insert them right after `GetSnackBar(`
    
    def inject_get_snackbar(match):
        return "GetSnackBar(\n          snackPosition: SnackPosition.TOP,\n          margin: const EdgeInsets.all(16),\n          borderRadius: 8,\n          duration: const Duration(seconds: 3),\n          "
    
    new_content = re.sub(r'\bGetSnackBar\s*\(\s*', inject_get_snackbar, new_content)

    # 4. Replace content: with messageText: (only within GetSnackBar context, but globally in this file is usually fine since we only match files that had ScaffoldMessenger and content: is rarely used elsewhere in these specific files except AlertDialog)
    # Wait, AlertDialog uses content: too!
    # So let's only replace `content: Text` with `messageText: Text`
    new_content = new_content.replace('content: Text', 'messageText: Text')
    new_content = new_content.replace('content: const Text', 'messageText: const Text')
    # What about content: Column(...)? in support_help_screen.dart
    # Let's just manually fix support_help_screen.dart if needed, or use a better replace:
    new_content = re.sub(r'content:\s*(Text|const Text|Column|MatchesProvider|authProvider|profileProvider|provider)', r'messageText: \1', new_content)

    # 5. Remove behavior: SnackBarBehavior.floating
    new_content = re.sub(r'behavior:\s*SnackBarBehavior\.(floating|fixed)\s*,?', '', new_content)

    # 6. Ensure import
    if "import 'package:get/get.dart';" not in new_content:
        imports = re.findall(r"^import\s+['\"].*?['\"];", new_content, flags=re.MULTILINE)
        if imports:
            last_import = imports[-1]
            new_content = new_content.replace(last_import, last_import + "\nimport 'package:get/get.dart';")
        else:
            new_content = "import 'package:get/get.dart';\n" + new_content

    with open(filepath, 'w') as f:
        f.write(new_content)
    print(f"Processed {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

