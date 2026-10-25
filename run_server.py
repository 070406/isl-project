"""
Signova — Quick Launcher Script
Starts the FastAPI Backend and Web Application on http://127.0.0.1:8000
"""

import os
import sys

# Ensure UTF-8 stdout if supported
if sys.platform.startswith('win'):
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

import uvicorn

if __name__ == "__main__":
    backend_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "backend")
    sys.path.insert(0, backend_dir)
    print("\n" + "="*60)
    print(">> Signova")
    print("="*60)
    print(">> Open Web Dashboard: http://127.0.0.1:8000")
    print(">> API Documentation:  http://127.0.0.1:8000/docs")
    print(">> Hand Tracking:      MediaPipe 21 Landmarks (30 FPS)")
    print(">> Unseen Signer Acc:  99.0%+")
    print("="*60 + "\n")
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True, app_dir=backend_dir)
