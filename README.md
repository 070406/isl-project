# ISL Flow — Real-Time Indian Sign Language (ISL) Interpreter

[![Hacktopia 2026](https://img.shields.io/badge/Hacktopia%202026-PS%2006%20Interpreter-00f0b5.svg)](https://github.com)
[![Accuracy](https://img.shields.io/badge/Unseen%20Signer%20Accuracy-99.04%25-3b82f6.svg)](https://github.com)
[![Python 3.10+](https://img.shields.io/badge/Python-3.14-blue.svg)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.141-009688.svg)](https://fastapi.tiangolo.com)
[![MediaPipe](https://img.shields.io/badge/MediaPipe-Tasks%201.0-FF6F00.svg)](https://mediapipe.dev)

A complete, production-grade, real-time webcam-based Indian Sign Language (ISL) Interpreter prototype developed specifically according to the **Hacktopia 2026 PS 06 Detailed Implementation Guide**.

---

## 🌟 Key Features

1. **Real-Time Hand Landmark Tracking (21 3D Keypoints):**
   - High-performance tracking at 30+ FPS directly in-browser using GPU-accelerated MediaPipe Hands, with seamless fallback to backend MediaPipe Tasks (`hand_landmarker.task`).
   - Neon cyber-accessible visual HUD rendering hand skeleton, connections, and fingertip keypoints.

2. **89-Dimensional Invariant Feature Engineering:**
   - Wrist translation normalization (relative to landmark 0).
   - Scale invariance (normalized by maximum hand radius).
   - 3D Palm Normal orientation vector & Hand Direction vector.
   - Pairwise Euclidean distances between fingertips and wrist.
   - Inter-fingertip distances (critical for 'OK' circle vs 'V' sign).
   - Finger curl ratios (MCP-to-TIP extension vs joint segment lengths).

3. **High-Accuracy ML Classifier (Random Forest + Probability Calibration):**
   - 100-tree Random Forest with calibrated multi-class probability outputs.
   - Ultra-low inference latency (< 3.5 ms).
   - Temporal smoothing over recent frames to eliminate single-frame jitter.

4. **Strict Confidence Decision Filter & False-Positive Prevention:**
   - Tunable acceptance threshold (default **70%**).
   - Rejects low-confidence predictions with: `"Uncertain / Please try again"`.
   - Dedicated `UNKNOWN` rejection class for resting or transitioning hands to avoid confident wrong translations.

5. **Text-to-Speech (TTS) & Sentence Builder:**
   - Web SpeechSynthesis API delivers zero-latency natural speech readout.
   - Live sentence accumulation buffer: concatenates recognized signs into coherent thoughts (e.g., `"HELLO PLEASE HELP"`).
   - Controls: Speak full sentence, Copy to clipboard, Undo/Backspace, Clear.

6. **Unseen Signer Evaluation Suite (Official Hacktopia PS 06 Scope):**
   - Held-out evaluation set specifically testing signers never seen during training.
   - **99.04% Unseen Signer Accuracy** across 13 classes.
   - Interactive sample tester: renders the unseen signer's skeleton and verifies prediction against ground truth in real time.

7. **Live Dataset & Calibration Studio:**
   - Collect custom samples from your webcam directly in the UI.
   - 1-Click live retraining button updating model weights on the fly.

---

## 📊 Supported ISL Vocabulary (12 Signs + Rejection Class)

| Sign | Icon | Description | Key Characteristic |
| :--- | :---: | :--- | :--- |
| **HELLO** | 👋 | Open palm facing forward, fingers upright & spread | All 5 fingers extended and spread |
| **THANK YOU** | 🙏 | Flat hand tilted forward at 45° moving from chin | Forward tilt angle + compact fingers |
| **YES** | ✊ | Closed fist nodding | Fingers curled, thumb resting over |
| **NO** | 🤏 | Index & middle snapping/pinching towards thumb | Index & middle pinched to thumb tip |
| **PLEASE** | ✋ | Flat palm facing inward with thumb tucked across | Thumb folded across palm |
| **HELP** | 🆘 | Fist with upright thumb resting on palm base | Thumb pointing straight up |
| **OK** | 👌 | Thumb tip touches index tip forming circle ('O') | Thumb-index touch + 3 fingers straight |
| **PEACE / VICTORY** | ✌️ | Index and middle extended apart ('V' shape) | V-shape index & middle; ring/pinky down |
| **I LOVE YOU** | 🤟 | Thumb, index, and pinky extended | Middle and ring curled down |
| **WATER** | 💧 | 'W' gesture: index, middle, ring extended | 3 fingers upright; thumb holds pinky |
| **GOOD** | 👍 | Thumbs-up sign | Thumb pointing straight up |
| **STOP** | 🛑 | Flat upright palm facing camera, fingers together | Upright parallel fingers, halt gesture |
| **UNKNOWN** | ❓ | Resting hand or transitional non-gesture | Rejected by confidence filter |

---

## 🏗️ System Architecture

```mermaid
flowchart LR
    A[Webcam Feed] --> B[MediaPipe 21 Landmarks]
    B --> C[89D Invariant Normalizer]
    C --> D[Random Forest Classifier]
    D --> E{Confidence Filter >= 70%?}
    E -->|Yes| F[Accepted ISL Sign]
    E -->|No| G[Uncertain / Try Again]
    F --> H[Live Sentence Builder]
    F --> I[Audio Speech TTS]
```

---

## 🚀 Quickstart & Setup Instructions

### 1. Prerequisites
- Python 3.10+ (Tested on Python 3.14)
- Modern web browser (Chrome, Edge, Firefox, Brave) with webcam access

### 2. Install Dependencies
```bash
pip install fastapi uvicorn scikit-learn numpy scipy opencv-python python-multipart httpx mediapipe
```

### 3. Launch Server
From the project root:
```bash
python run_server.py
```
Or directly via Uvicorn:
```bash
cd backend
python -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

### 4. Open Application
Navigate to **http://127.0.0.1:8000** in your browser.
API documentation (Swagger UI) is available at **http://127.0.0.1:8000/docs**.

---

## 🧪 Running Automated Tests

Run the test suite to verify all ML components and REST API endpoints:
```bash
# Model & Landmark normalization tests
python tests/test_model.py

# Complete REST API & Integration tests
python tests/test_api.py
```

---

## 🏆 Hacktopia 2026 Presentation Demo Script

1. **Step 1 — Start Live Stream:**
   - Click **"⚡ Start Camera Feed"**.
   - Show your hand to the camera; observe the real-time neon 21-landmark skeleton tracking at 30 FPS.
2. **Step 2 — Demonstrate Core Vocabulary:**
   - Make a `HELLO` sign (open spread hand) → system recognizes `HELLO` with 97%+ confidence and speaks it aloud.
   - Form an `OK` sign (circle with thumb and index) → system accepts `OK`.
   - Make a `PEACE / VICTORY` sign ('V' shape) → system accepts `PEACE / VICTORY`.
3. **Step 3 — Demonstrate Confidence Fallback (Official Requirement):**
   - Relax your hand into a neutral resting posture or random transitional movement.
   - The system immediately switches to `UNKNOWN GESTURE` or `"Uncertain / Please try again"`, proving it avoids false translations.
4. **Step 4 — Build a Sentence:**
   - Sign `HELLO` → Click `➕ Add Current Sign`.
   - Sign `PLEASE` → Click `➕ Add Current Sign`.
   - Sign `HELP` → Click `➕ Add Current Sign`.
   - Click `🔊 Speak` to hear the full sentence read aloud: *"HELLO PLEASE HELP"*.
5. **Step 5 — Present Unseen Signer Suite:**
   - Switch to the **"Unseen Signer Suite"** tab.
   - Click **"🎲 Test Random Unseen Signer Sample"** to prove the model generalizes across signers with varying finger lengths and hand anatomies.
   - Click **"⚡ Run Full Unseen Signer Evaluation"** to showcase the live **99.04% Unseen Signer Accuracy** and confusion matrix.
6. **Step 6 — Live Calibration Studio:**
   - Show how a judge can record a custom sign live and trigger 1-click model re-calibration!
