# Safini AI - Earned Screen Time Platform 🚀

Safini AI is a dual-mode parental control and habit-building application built with Flutter. It helps families replace screen-time conflict with a balanced "earned-time" system powered by **Time Coins**.

## 🌟 Core Concept
Children earn Time Coins by completing productive tasks (Duolingo, daily steps, logic puzzles, homework) and spend them to unlock entertainment minutes in controlled apps like YouTube, Roblox, and Minecraft.

## 🛠️ Tech Stack
- **Framework**: Flutter (Cross-platform iOS/Android)
- **State Management**: Riverpod (Reactive and scalable)
- **Database**: Hive (High-performance, offline-first local persistence)
- **Design**: Modern, premium UI using the Outfit typography and FontAwesome.

## 📱 Features

### Kids Mode
- **Mission Feed**: List of tasks categorized by Language, Brain, Movement, and more.
- **Reward Shop**: Secure session unlocking using earned Time Coins.
- **AI Friend**: Initial integration of a child-facing AI assistant for encouragement.
- **Streaks & Progress**: Gamified progression system to drive long-term habit formation.

### Parent Mode
- **Task Creator**: Form to set custom or template-based goals.
- **Approval Queue**: Streamlined verification flow for child-submitted "proof".
- **Insight Dashboard**: Monitor coin earnings and app-time consumption.

## 🚀 Getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
2. **Generate Models**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. **Run the App**:
   ```bash
   flutter run
   ```

## 📅 Roadmap
- **Phase 1 (MVP)**: Core earned-time loop with local persistence (Completed).
- **Phase 2 (Sync)**: Firebase integration for multi-device family synchronization.
- **Phase 3 (Enforcement)**: Device-level screen-time API integration for automated enforcement.

## 📄 Documentation
This project is the technical implementation of the **Safini AI Pivot Product Requirements Document**. It translates the vision of an earned-time rewards system into a functional Flutter mobile prototype.

---
*MVP Implementation based on departmental requirements.*
