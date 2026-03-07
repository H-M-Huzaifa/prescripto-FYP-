# Prescripto

Final Year Project — ranked **1st in the Software Engineering Department at CECOS University**  

**Prescripto** is an intelligent mobile application that streamlines medicine ordering and prescription interpretation for users and pharmacies. Built in Flutter and powered by applied AI, the app allows users to upload prescriptions, extract medicine names, and interact with a domain-specific chatbot for guidance on medicines, dosage, and general information.  

---

## Prescripto — Prescription Digitization Platform

A healthcare application designed to help pharmacies and patients process handwritten prescriptions more reliably by extracting medicine names from prescription images.

**Key components:**

- CRNN model for handwritten prescription recognition  
- Confidence-based fallback to Azure Vision API for improved reliability  
- NLP pipeline to normalize and match medicine names against a medicine dataset  
- AI-powered chatbot trained on medicine-related knowledge to assist users with prescription queries  
- Flutter mobile application with a custom UX workflow for scanning prescriptions and browsing medicines

The system simplifies prescription interpretation and supports digital workflows for pharmacies and online medicine ordering platforms.

---

## Prescripto in Action

Demo GIF showcasing prescription upload, medicine extraction, and chatbot interaction:

<p align="center">
  <img src="assets/gif/demo.gif" width="600">
</p>

### Screenshots

<p align="center">
  <img src="assets/images/screenshot1.png" width="300">
  <img src="assets/images/screenshot2.png" width="300">
</p>

---

## Features

### AI-Powered Prescription Processing
- Upload prescription images and automatically extract medicine names.
- Reduces manual errors and speeds up order placement.

### Medicine Assistant Chatbot
- Provides guidance on medicine usage, purpose, dosage, and precautions.
- Simplifies medical guidance for users unfamiliar with prescriptions.
- *(Informational only, not for medical diagnosis.)*

### Intuitive & Modern UI
- Clean, minimal, and easy-to-navigate interface.
- Smooth transitions and optimized layout for all screen sizes.

### Smart Medicine Ordering
- Add extracted medicines to the cart, customize quantities, and checkout.
- Reorder frequently used medicines with one tap.
- Track order status in real-time.

### Secure Authentication
- Safe login and signup process.
- Handles user identity, order history, and prescription records securely.

### MVVM Architecture
- Separation of UI, business logic, and data for maintainability and scalability.
- Built with Provider for state management.

---

## High-Level Workflow

1. User logs in and uploads a prescription image.
2. CRNN model extracts text from handwriting.
3. NLP pipeline normalizes text and matches medicine names from the dataset.
4. User can query the chatbot for guidance.
5. Extracted medicines can be added to the cart.
6. User places the order → pharmacy updates status.
7. Live order tracking available for the user.

---

## Tech Stack

| Category        | Tools / Technologies                              |
| --------------- | ------------------------------------------------- |
| Frontend        | Flutter, Dart                                     |
| Architecture    | MVVM + Provider                                   |
| AI / ML         | CRNN for handwriting recognition + NLP post-processing |
| Chatbot         | Domain-specific retrieval / LLM API              |
| Backend         | Firebase / Node.js / Django                       |
| Database        | Firebase Firestore / SQLite / API-based          |
| Authentication  | Firebase Auth / JWT                               |
| Version Control | Git & GitHub                                      |
| UI/UX           | Figma (Google UX-certified workflow)              |

---

## Installation

Clone the repository:

```bash
git clone https://github.com/your-username/prescripto.git
cd prescripto
flutter pub get
flutter run
