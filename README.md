# Prescripto

Final Year Project — ranked **1st in the Software Engineering Department at CECOS University**  

**Prescripto** is an intelligent mobile application that streamlines medicine ordering and prescription interpretation for users and pharmacies. Built in Flutter and powered by applied AI, the app allows users to upload prescriptions, extract medicine names, and interact with a domain-specific chatbot for guidance on medicines, dosage, and general information.  

---

## Features

### AI-Powered Prescription Processing
* Upload prescription images and automatically extract medicine names.
* CRNN-based handwriting recognition with a post-processing NLP pipeline for normalization and dataset matching.
* Reduces manual errors and speeds up order placement.

### Medicine Assistant Chatbot
* Provides guidance on medicine usage, purpose, dosage, and precautions.
* Simplifies medical guidance for users unfamiliar with prescriptions.
* *(Note: chatbot is informational only, not for medical diagnosis.)*

### Intuitive & Modern UI
* Clean, minimal, and easy-to-navigate interface.
* Smooth transitions and optimized layout for all screen sizes.
* UX designed following Google UX best practices.

### Smart Medicine Ordering
* Extracted medicines can be added to the cart, customized, and checked out.
* Users can reorder frequently used medicines with one tap.
* Order tracking for live updates from pharmacies.

### Secure Authentication
* Safe login and signup process.
* Handles user identity, order history, and prescription records securely.

### MVVM Architecture
* Separation of UI, business logic, and data for maintainability and scalability.
* Built with Provider for state management.

---

## Prescripto in Action

Below is a short demo showing the **prescription upload, medicine extraction, and chatbot workflow**:  

<p align="center">
  <img src="assets/gif/demo.gif" width="600">
</p>

You can also add screenshots for:
* Home screen
* Upload prescription
* Extracted result screen
* Chatbot interface
* Cart & order flow
* Order tracking

Use: `![Description](assets/images/screenshot.png)` to embed images.

---

## Tech Stack

| Category        | Tools / Technologies                              |
| --------------- | ------------------------------------------------- |
| Frontend        | Flutter, Dart                                     |
| Architecture    | MVVM + Provider                                   |
| AI / ML         | CRNN for handwriting recognition + NLP post-processing |
| Chatbot         | Domain-specific retrieval / LLM API              |
| Backend         | Firebase / Node.js / Django (specify your choice) |
| Database        | Firebase Firestore / SQLite / API-based          |
| Authentication  | Firebase Auth / JWT                               |
| Version Control | Git & GitHub                                      |
| UI/UX           | Figma (Google UX-certified workflow)              |

---

## High-Level Workflow

1. User logs in and uploads a prescription image.
2. CRNN model extracts text from handwriting.
3. NLP pipeline normalizes extracted text and matches medicine names from the dataset.
4. User can query the chatbot for medicine guidance.
5. Extracted medicines can be added to the cart.
6. User places the order → pharmacy updates status.
7. Live order tracking available for the user.

---

## Installation

Clone the project:

```bash
git clone https://github.com/your-username/prescripto.git
cd prescripto
flutter pub get
flutter run
