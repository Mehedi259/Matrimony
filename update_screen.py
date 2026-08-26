import re

with open('/Users/mehedihasanmridul/app/Matrimony/lib/features/main_navigation/presentation/screens/matched_profile_view_screen.dart', 'r') as f:
    content = f.read()

# I will replace the state variables
old_vars = """  bool _hasMarkedViewed = false;
  bool? _initialIsBlurred;
  int _currentPhotoIndex = 0;
  
  bool _hasViewedOnce = false;
  int _secondsLeft = 60;
  Timer? _timer;"""

new_vars = """  bool _hasMarkedViewed = false;
  bool? _initialIsBlurred;
  int _currentPhotoIndex = 0;
  
  int _secondsLeft = 60;
  Timer? _timer;
  bool _timerExpired = false;"""

content = content.replace(old_vars, new_vars)

# Replace dispose
old_dispose = """  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }"""
new_dispose = old_dispose
# it's fine

# Replace the build method logic
build_start_idx = content.find("  @override\n  Widget build(BuildContext context) {")
if build_start_idx != -1:
    print("Found build method")

    # Let's replace the _startPhotoTimer method since we won't need the popup dialog anymore
    timer_method_start = content.find("  void _startPhotoTimer")
    cancel_method_start = content.find("  void _showCancelConnectionDialog")
    if timer_method_start != -1 and cancel_method_start != -1:
        content = content[:timer_method_start] + content[cancel_method_start:]

