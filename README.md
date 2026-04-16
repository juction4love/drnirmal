🏥 Dr. Nirmal Lamichhane - Professional Portfolio

This is the official professional web portal for Dr. Nirmal Lamichhane, Senior Consultant Urological Surgeon and Medical Director at National City Hospital, Bharatpur.

The system is a high-performance single-page application (SPA) built using vanilla HTML, CSS, and JavaScript.

🚀 Key Features
🌐 Bilingual Support (i18n)

Full support for English and Nepali languages using a custom JSON-based translation engine.

📱 Fully Responsive Design

Optimized for all devices with a custom mobile hamburger navigation system.

🔍 SEO Optimized

Structured data designed for medical professionals, improving visibility for urology-related searches in Nepal.

⚡ Lightweight Architecture

No heavy frameworks — only HTML, CSS, JavaScript, with minimal dependencies (FontAwesome + Google Fonts).

🛠 Project Structure
├── index.html          # Main portal (UI + translation logic)
├── profile.png         # Doctor profile image
├── hospital-bg.jpg     # Hero background image
├── about.html          # About page
├── services.html       # Services page
└── assets/             # Additional static resources
🌍 Translation System

The website uses a data-key based dynamic translation system that allows instant language switching without page reload.

✏️ How to Edit Content

All translations are stored inside the translations object in the <script> section.

Steps:
Open the script file
Locate en or ne object
Find the required key (e.g., sec1_p)
Update the string value
ne: {
    h_title: "वरिष्ठ कन्सल्टेन्ट सर्जन"
}
📱 Mobile Navigation

The navigation system uses a JavaScript-based toggle menu.

⚙️ Behavior:
Breakpoint: 850px
Toggle action: .menu-btn
Class change: .active on .nav-links
