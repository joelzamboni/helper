


# Load libraries in the lib directory
import sys
import os.path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'lib'))

# Force stdout flush
sys.stdout = os.fdopen(sys.stdout.fileno(), 'w', 0)
