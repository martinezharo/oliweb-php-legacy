# Oliweb PHP (Legacy)

This repository contains the legacy source code of my former personal website. This version of the site served as a central hub for my professional projects, blog posts, and coding practices.

> **Note**: This is legacy code. I have since moved to a completely different and improved version for my current production site. I am sharing this for educational purposes or for anyone who might find parts of the structure useful.

## 🚀 Overview

The project is built on a custom **PHP MVC-inspired architecture**. It features a custom router, a basic controller system, and a unique way of handling dynamic content where MySQL triggers and stored procedures generate HTML snippets that are then injected into pages.

### Key Features
- **Multi-language Support**: Full support for English and Spanish content.
- **Dynamic Content**: Managed blog articles, current projects, past projects, and "practice" projects.
- **Custom Router**: A lightweight PHP routing system.
- **DB-Driven Layouts**: Extensive use of MySQL stored procedures to manage section injections.
- **SEO Ready**: Custom meta titles and descriptions for every page and article.

## 🛠️ Tech Stack
- **Backend**: PHP 8.x
- **Database**: MySQL / MariaDB
- **Frontend**: Vanilla HTML5, CSS3, and JavaScript
- **Server**: Apache (includes `.htaccess` for URL rewriting)

## 📁 Project Structure
- `public_html/` — The document root. Contains `index.php`, assets, and robots.txt.
- `src/` — Core application logic.
  - `controllers/` — Logic for articles, pages, and projects.
  - `Database.php` — Database connection wrapper.
  - `Router.php` — Custom request handling.
- `templates/` — View files and layouts.
- `config/` — Configuration files (DB credentials).
- `database-structure.sql` — Complete schema including stored procedures and triggers.

## ⚙️ Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/martinezharo/oliweb-php-legacy.git
   ```
2. **Setup the Database**:
   - Create a new MySQL database.
   - Import `database-structure.sql`.
3. **Configure the App**:
   - Navigate to `config/database.php`.
   - Update your database credentials (username, password, db name).
4. **Server Config**:
   - Ensure your web server (Apache/Nginx) points to the `public_html/` directory.
   - Make sure `mod_rewrite` is enabled on Apache for the `.htaccess` to work.

## � License

This project is open-source and available under the **MIT License**. Feel free to use, modify, and distribute it as you wish.

---
*Created by [Oliver Martínez](https://olivermartinezharo.com)*
