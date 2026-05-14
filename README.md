# Granth 📖
*A Neo-Brutalist E-Book Discovery & Reading App*

> **"Granth"** — Sanskrit for *manuscript*

Built with Flutter · Firebase · Open Library · Project Gutenberg · Gemini AI

---

## Overview

Granth is a free, fully-featured mobile e-book app for readers who want one place to discover, save, and read books — without paying for content. It combines real book data from Open Library (4M+ books), free classic literature from Project Gutenberg, Firebase-backed personal libraries, and an AI book assistant powered by Gemini.

---

## Features

| Feature | Details |
|---|---|
| 🔍 Book Discovery | Search 4M+ books via Open Library API |
| 📚 Free Reading | Classic literature via Project Gutenberg |
| ❤️ Personal Library | Save books, synced to cloud via Firestore |
| 🔐 Auth | Email/password login via Firebase Auth |
| 🤖 AI Chat | Book recommendations & discussion via Gemini 2.0 Flash |
| 📊 Reading Activity | GitHub-style contribution heatmap + streak tracking |
| 📵 Offline Handling | Graceful fallback with retry via connectivity_plus |
| 👤 Profile | Username, reading stats, activity graph |

---

## Tech Stack

- **Framework**: Flutter (Dart)
- **Backend**: Firebase (Auth + Firestore)
- **State Management**: Provider (`GranthAuthProvider`)
- **APIs**:
  - [Open Library](https://openlibrary.org/developers/api) — book search & metadata
  - [Gutendex](https://gutendex.com/) — Gutenberg book index
  - [Project Gutenberg](https://www.gutenberg.org/) — free plain text books
  - [Google Gemini](https://ai.google.dev/) — AI chat (gemini-2.0-flash)

---

## Project Structure

```
lib/
├── main.dart                  # App entry, Firebase init, dotenv, Provider setup
├── models/
│   └── book.dart              # Book model — fromJson, fromMap, toMap
├── pages/
│   ├── home_page.dart         # Splash + login sheet
│   ├── main_page.dart         # Browse + search + recommendations
│   ├── book_detail_page.dart  # Cover, summary, save/read buttons
│   ├── reader_page.dart       # Gutenberg text reader
│   ├── saved_page.dart        # Personal library
│   ├── profile_page.dart      # Stats + reading activity graph
│   └── chat_page.dart         # Gemini AI assistant
├── services/
│   ├── auth_service.dart
│   ├── book_service.dart
│   ├── firestore_service.dart
│   ├── gutenberg_service.dart
│   └── gemini_service.dart
├── providers/
│   └── granth_auth_provider.dart   # ChangeNotifier auth state
└── widgets/
    ├── no_connection_widget.dart
    └── reading_activity_graph.dart
```

---

## Setup

### 1. Clone the repo

```bash
git clone https://github.com/yourusername/granth.git
cd granth
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Firebase setup

- Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
- Enable **Email/Password** auth
- Create a **Firestore** database
- Run `flutterfire configure` and follow the prompts — it generates `firebase_options.dart` automatically

### 4. Gemini API key

Create a `.env` file in the project root:

```
GEMINI_API_KEY=your_key_here
```

Get a free key at [ai.google.dev](https://ai.google.dev). The `.env` file is excluded from git via `.gitignore`.

### 5. Run

```bash
flutter run
```

---

## Firestore Data Model

```
users/
  {uid}/
    savedBooks/
      {sanitized_book_id}     # id, title, author, coverId, summary, savedAt
    readingActivity/
      {YYYY-MM-DD}            # date, count
```

> **Note:** Open Library IDs contain forward slashes (e.g. `/works/OL45804W`) which break Firestore paths. All IDs are sanitized by replacing `/` with `_` before any Firestore write.

---

## Design Language

Granth uses a **neo-brutalist** design system — hard geometry, raw contrast, flat offset shadows, no gradients.

| Token | Hex | Usage |
|---|---|---|
| Background | `#F5F0E8` | Warm off-white, all page backgrounds |
| Accent | `#FF3F00` | Buttons, highlights, activity graph |
| Text / Border | `#000000` | All borders, primary text |
| Secondary Text | `#00000089` | Author names, metadata, hints |

**Fonts:** Comforter (display) · JimNightshade (labels/titles) · Arial (body)

---

## Key Technical Notes

- **`StreamBuilder` on `authStateChanges()`** — app root listens to Firebase auth stream, auto-routes between `HomePage` and `MainPage` with no manual navigation
- **`ListView.builder` in ReaderPage** — virtualizes paragraph rendering so 500k+ character books load instantly
- **Gutenberg text parsing** — strips license boilerplate before `*** START OF` / after `*** END OF` markers, detects chapter headings by length + capitalization
- **Gemini context** — full conversation history passed with every request for session-aware responses

---

## Dependencies

```yaml
dependencies:
  flutter:
  firebase_core:
  firebase_auth:
  cloud_firestore:
  provider:
  http:
  connectivity_plus:
  flutter_dotenv:
  lottie:
```

---

## License

This project is for educational purposes as part of a university Mobile Application Development course at The NorthCap University, Gurugram.