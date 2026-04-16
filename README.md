Dr. Nirmal Lamichhane - Professional Portfolio
This is the official professional web portal for Dr. Nirmal Lamichhane, Senior Consultant Urological Surgeon and Medical Director at National City Hospital, Bharatpur. The site is a high-performance, single-page application (SPA) architecture built with vanilla HTML, CSS, and JavaScript.

🚀 Key Features
Bilingual Support (i18n): Full support for English and Nepali languages via a custom JSON-based translation engine.

Fully Responsive: Optimized for all devices, featuring a custom-built mobile "Hamburger" navigation menu.

SEO Optimized: Structured data for medical professionals, ensuring high visibility in search results for urology services in Nepal.

Zero Dependencies: Light-weight and fast-loading, using only FontAwesome for iconography and Google Fonts.

🛠 Project Structure
Plaintext
├── index.html          # Main portal containing UI and Translation Logic
├── profile.png         # Professional portrait of Dr. Nirmal
├── hospital-bg.jpg     # Hero section background image
└── (Other Pages)       # about.html, services.html, etc.
🌍 Translation System
The website uses a data-key attribute system to switch languages instantly without a page reload.

How to Edit Content:
All text is stored in the const translations object within the <script> tag. To update a paragraph:

Locate the en (English) or ne (Nepali) object.

Find the specific key (e.g., sec1_p for the first section paragraph).

Update the text within the quotes.

JavaScript
// Example: Updating the Nepali Title
ne: {
    h_title: "वरिष्ठ कन्सल्टेन्ट सर्जन", // Change this text
}
📱 Mobile Navigation
The navigation system uses a JavaScript toggle to handle mobile views.

Breakpoints: The menu switches to mobile mode at 850px.

Logic: The .menu-btn triggers the toggleMenu() function, which toggles the .active class on the .nav-links element.

🔧 Installation & Deployment
Clone the Repository:

Bash
git clone https://github.com/juction4love/dr-nirmal-web.git
Local Development: Simply open index.html in any modern web browser.

Deployment: The site is ready for deployment on GitHub Pages, Netlify, or any standard PHP/Static hosting provider.

🩺 Clinical Information Accuracy
All medical details (NMC No. 3267, Specializations in Uro-Oncology, and Neobladder reconstruction) must be verified against official clinical records before deployment.

Main Clinic: National City Hospital, Bharatpur, Chitwan, Nepal.
