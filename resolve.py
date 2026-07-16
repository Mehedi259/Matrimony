import os
import glob

def find_conflicts(filepath):
    with open(filepath, 'r') as f:
        lines = f.readlines()
    
    conflicts = []
    in_conflict = False
    current_conflict = []
    
    for i, line in enumerate(lines):
        if line.startswith('<<<<<<< HEAD'):
            in_conflict = True
            current_conflict = [f"Line {i+1}: {line}"]
        elif line.startswith('======='):
            current_conflict.append(f"Line {i+1}: {line}")
        elif line.startswith('>>>>>>> '):
            current_conflict.append(f"Line {i+1}: {line}")
            conflicts.append(current_conflict)
            in_conflict = False
        elif in_conflict:
            current_conflict.append(f"Line {i+1}: {line}")
            
    return conflicts

files = [
    'lib/features/auth_onboarding/presentation/screens/basic_information_screen.dart',
    'lib/features/auth_onboarding/presentation/screens/signup_screen.dart',
    'lib/features/auth_onboarding/presentation/screens/your_preferences_screen.dart',
    'lib/features/main_navigation/presentation/screens/browse_screen.dart',
    'lib/features/main_navigation/presentation/screens/home_screen.dart',
    'lib/features/main_navigation/presentation/screens/profile_view_details_screen.dart',
    'lib/features/main_navigation/presentation/screens/requests_screen.dart'
]

for file in files:
    print(f"\n--- {file} ---")
    conflicts = find_conflicts(file)
    for i, c in enumerate(conflicts):
        print(f"\nConflict {i+1}:")
        print("".join(c))

