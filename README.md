# 🖐️ VibroBraille Hybrid: AI-Powered Tactile Literacy

VibroBraille Hybrid is a cutting-edge assistive technology system that bridges the gap between digital text and tactile sensation. By leveraging **Google Gemini AI**, the system simplifies complex information into concise, braille-ready segments and transmits them to a mobile device for real-time haptic feedback.

---

## 📺 Demo

| AI Dashboard (Web) | Mobile Haptic Interface |
| :---: | :---: |
| ![VibroBraille Web Interface](assets/vibrobraile_web.gif) | ![VibroBraille Mobile App](assets/vibrobraile_mob.gif) |
| *Processing & Simplifying Text* | *Real-time Tactile Delivery* |

---

## ✨ Key Features

- **🤖 Gemini AI Integration**: Automatically simplifies long, complex sentences into core meanings optimized for braille reading.
- **⚡ Real-time Relay**: Low-latency WebSocket connection between the "Brain" (Web) and the "Body" (Mobile).
- **📳 Haptic Waveform Encoding**: Converts braille dot patterns into specific vibration timings and amplitudes.
- **📱 Hybrid Architecture**: Combines a powerful Node.js/Express backend with a responsive Flutter mobile application.
- **🔗 Session Syncing**: Easy pairing between devices using unique Session IDs.

---

## 🏗️ System Architecture

1.  **The Brain (Web/Backend)**: Built with Node.js, Express, and Socket.io. It hosts the Gemini pipeline and the pairing dashboard.
2.  **The Pipeline**: Standardizes text ➔ Simplifies with Gemini 1.5 Flash ➔ Relays via WebSockets.
3.  **The Body (Mobile)**: Flutter app that translates simplified text into Braille patterns and emits custom haptic pulses via Native Method Channels.

---

## 🚀 Getting Started

### 1. Backend Setup (The Brain)
```bash
cd web
npm install
```
- Create a `.env` file in the `web` directory:
  ```env
  GEMINI_API_KEY=your_key_here
  PORT=3000
  ```
- Start the server:
  ```bash
  npm start
  ```

### 2. Mobile Setup (The Body)
- Ensure you have the Flutter SDK installed.
- Open `mobile/lib/main.dart` and update the IP address to match your computer's local IP:
  ```dart
  url: 'ws://YOUR_COMPUTER_IP:3000'
  ```
- Run the app:
  ```bash
  cd mobile
  flutter pub get
  flutter run
  ```

---

## 🛠️ Technology Stack

- **Backend**: Node.js, Express.js, WebSocket (`ws`)
- **AI**: Google Generative AI (Gemini SDK)
- **Frontend**: HTML5, Bootstrap 5 (Glassmorphism UI)
- **Mobile**: Flutter, Provider (State Management)
- **Communication**: Custom JSON-based WebSocket Protocol

---

## 🤝 Contributing

Contributions are welcome! Whether it's improving the haptic encoding patterns or enhancing the AI simplification prompts, feel free to fork and PR.

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.
