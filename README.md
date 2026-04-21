# Todo Flutter App

A simple and clean Todo application built with Flutter.

This project demonstrates state management, local storage, and clean UI design in a small but complete mobile application.

---

## Features

- Create new todo
- Edit existing todo
- Delete todo (swipe to delete)
- Mark todo as completed
- Strike-through style for completed todos
- Search todos (Title, Description)
- Sort todos (Date / Title / Status)
- Local storage persistence
- Image attachment for todos

---

## Tech Stack

- Flutter
- Dart
- Riverpod (state management)
- SharedPreferences (local storage)
- Image Picker

---

## Project Structure

lib/
│
├── models/
│ └── todo_model.dart
│
├── providers/
│ └── todo_provider.dart
│
├── screens/
│ ├── todo_list_screen.dart
│ ├── create_todo_screen.dart
│ └── edit_todo_screen.dart
│
├── theme/
│ └── app_theme.dart
│
├── widgets/
│ └── todo_text_field.dart
│
├── widgets/
│ └── todo_text_field.dart
│
└── main.dart

---

## Architecture

The project uses **Riverpod** for state management to keep UI and business logic separated.

Key design decisions:

- Provider handles todo state and logic
- Screens focus on UI rendering
- Reusable widgets reduce duplicated UI code
- Utility functions centralize shared logic (image picker / date picker)

This structure helps maintain scalability and readability.

---

## Screens

### Todo List Screen

- Display all todos
- Toggle completion status
- Swipe to delete
- Search and sorting

### Create Todo Screen

- Create new todo
- Select date
- Attach image

### Edit Todo Screen

- Update title, description, date
- Update status
- Update image

---

## UX Improvements

Some additional UX details implemented:

- Strike-through for completed todos
- Swipe gesture for delete
- Rounded UI components
- Empty state UI
- Bottom action button

---

## Getting Started

Run the following commands:

flutter pub get
flutter run

---

## Author

Developed by Wijitra Rattanason

---

## Screenshots

### Todo List Screen

![Todo List](screenshots/todo_list.png)

### Create Todo Screen

![Create Todo](screenshots/create_todo.png)

### Edit Todo Screen

![Edit Todo](screenshots/edit_todo.png)
