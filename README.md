# VibroBraille Hybrid (V3): AI-Powered Tactile Literacy

**Winner/Entry for [Hackathon Name]**

VibroBraille Hybrid is an assistive technology system designed to bridge the gap between digital text and tactile sensation. Leveraging **Google Gemini 1.5 Pro**, the system simplifies complex information into concise, braille-ready segments and transmits them to a mobile device for real-time haptic feedback.

---

## 🎥 Demonstration

| AI Dashboard (Web) | Mobile Haptic Interface |
| :---: | :---: |
| ![VibroBraille Web Interface](assets/vibrobraile_web.gif) | ![VibroBraille Mobile App](assets/vibrobraile_mob.gif) |
| *Processing, Simplifying, & Broadcasting* | *Real-time Tactile Delivery via Vibration* |

---

## 🌟 Key Features

- **Gemini 1.5 Pro Brain**: Automatically simplifies complex sentences ("Simp-Tactile" Processing) to reduce cognitive load for haptic reading.
- **QR Code Pairing**: Instant, zero-config connection between the PC Brain and Mobile Actuator.
- **Multimodal Ingestion**: "Feel" images and PDFs. The system extracts text, describes images, and converts them to Braille.
- **Broadcast Architecture**: Controls multiple haptic devices simultaneously from a single Conductor dashboard.
- **Adaptive Haptics**: Native Android Waveform engine with active motor cancellation to prevent overheating and signal overlap.

---

## 🛠️ System Architecture

1.  **The Conductor (PC)**: Node.js/Express server. Handles AI processing, state management, and WebSocket broadcasting.
2.  **The Actuator (Mobile)**: Flutter app. Scans QR code to connect. Translates text to **Temporal Braille Patterns** and drives the phone's vibration motor.
3.  **The Protocol**: Custom WebSocket events (`SET_SENTENCE`, `WORD`, `SPEED`) for synchronized haptic storytelling.

---

## 🚀 Getting Started

### Prerequisites
- **Node.js** (v16+)
- **Flutter SDK** (3.0+)
- **Android Phone** (Android 8.0+)
- **Google Gemini API Key**

### 1. The Brain (Backend)
1.  Navigate to `web/`:
    ```bash
    cd web
    npm install
    ```
2.  Create a `.env` file:
    ```env
    GEMINI_API_KEY=your_gemini_key_here
    PORT=3000
    ```
3.  Start the Conductor:
    ```bash
    node server.js
    ```
    *You will see a QR Code and Dashboard at `http://localhost:3000`*

### 2. The Body (Mobile App)
1.  Navigate to `mobile/`:
    ```bash
    cd mobile
    flutter pub get
    ```
2.  Run on your Android device:
    ```bash
    flutter run --release
    ```
    *(Note: Debug mode works, but Release mode offers better haptic timing accuracy)*

### 3. Connection
1.  Ensure Phone and PC are on the **Same Wi-Fi**.
2.  Open the App on your phone.
3.  Tap **"Link to Brain"**.
4.  Scan the **QR Code** displayed on your PC screen.
5.  **Success!** The phone is now a haptic terminal.

---

## 🎮 Usage Guide

- **Clipboard Mode (Background)**: Just copy any text (Ctrl+C) on your PC. It will immediately start vibrating on the phone.
- **Manual Mode**: Type text into the Web Dashboard and hit **PROCESS**.
- **Visual Mode**: Upload a PDF or Image. The AI will describe/read it to you tactually.

---

## 🔧 Troubleshooting

- **No Vibration?**
  - Ensure your phone is not in "Silent/Do Not Disturb" mode (some manufacturers block haptics).
  - Check the App Logs for `Waveform request received`.
- **Connection Failed?**
  - Check Windows Firewall (Allow Node.js).
  - Ensure both devices are on the same 2.4GHz/5GHz band.

---

## 📄 License
Distributed under the MIT License. See `LICENSE` for details.
