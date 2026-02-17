<!DOCTYPE html>
<html lang="<?= $lang ?>">
<head>
    <meta charset="UTF-8">
    <base href="/">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($meta_title ?? $title) ?></title>
    <meta name="description" content="<?= htmlspecialchars($meta_desc ?? '') ?>">
    <link rel="stylesheet" href="/assets/css/styles.css">
    <link rel="icon" type="image/jpeg" href="/assets/images/favicon.jpg">
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Mono:wght@400;700&display=swap" rel="stylesheet">
    <!-- Google tag (gtag.js) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-3Z2SJQ5VRV"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'G-3Z2SJQ5VRV');
    </script>
</head>
<body>
    <header class="main-header">
        <a href="<?= $lang == 'en' ? '/en/' : '/' ?>">
            <img src="/assets/images/favicon.jpg" alt="Logo">
        </a>
        <div class="lang-switch">
            <a href="<?= $lang == 'es' ? '#' : ($alternate_url ?? '/?lang=es') ?>" class="lang-option <?= $lang == 'es' ? 'active' : '' ?>">ES</a>
            <span class="lang-separator">/</span>
            <a href="<?= $lang == 'en' ? '#' : ($alternate_url ?? '/en/?lang=en') ?>" class="lang-option <?= $lang == 'en' ? 'active' : '' ?>">EN</a>
        </div>
    </header>

    <aside class="sidebar">
        <nav class="nav-menu">
            <?php foreach ($menuItems as $item): ?>
                <?php 
                    $slug = $item['slug'];
                    if ($slug === 'inicio' || $slug === 'home') {
                        $url = $lang == 'en' ? '/en/' : '/';
                    } else {
                        $url = ($lang == 'en' ? '/en/' : '/') . $slug;
                    }
                ?>
                <a href="<?= $url ?>" class="nav-link"><?= htmlspecialchars($item['title']) ?></a>
            <?php endforeach; ?>
        </nav>
    </aside>

    <main class="content">
        <?php if (!empty($title)): ?>
            <h1><?= htmlspecialchars($title) ?></h1>
        <?php endif; ?>
        
        <?= $content ?>
    </main>

    <footer class="main-footer">
        <div class="footer-container">
            <div class="footer-section">
                <h4 class="footer-title"><?= $lang == 'en' ? 'Active Projects' : 'Proyectos Activos' ?></h4>
                <ul class="footer-links">
                    <?php foreach ($activeProjects as $project): ?>
                        <li><a href="<?= htmlspecialchars($project['url']) ?>" target="_blank" rel="noopener"><?= htmlspecialchars($project['name']) ?></a></li>
                    <?php endforeach; ?>
                </ul>
            </div>
            <div class="footer-section">
                <h4 class="footer-title"><?= $lang == 'en' ? 'Legal' : 'Legal' ?></h4>
                <ul class="footer-links">
                    <?php foreach ($footerPages as $page): ?>
                        <?php 
                            $slug = $page['slug'];
                            $url = ($lang == 'en' ? '/en/' : '/') . $slug;
                        ?>
                        <li><a href="<?= $url ?>"><?= htmlspecialchars($page['title']) ?></a></li>
                    <?php endforeach; ?>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
             <p>&copy; <?= date('Y') ?> Oliver Martínez Haro. All rights reserved.</p>
         </div>
    </footer>

    <!-- Cookie Banner -->
    <div id="cookie-banner" class="cookie-banner" style="display: none;">
        <div class="cookie-content">
            <p>
                <?= $lang == 'en' 
                    ? 'This website uses cookies to improve your experience. By continuing to browse, you accept our <a href="/en/cookies">cookie policy</a>.' 
                    : 'Este sitio web utiliza cookies para mejorar tu experiencia. Al continuar navegando, aceptas nuestra <a href="/politica-cookies">política de cookies</a>.' 
                ?>
            </p>
            <button id="accept-cookies" class="cookie-btn">
                <?= $lang == 'en' ? 'Accept' : 'Aceptar' ?>
            </button>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const banner = document.getElementById('cookie-banner');
            const acceptBtn = document.getElementById('accept-cookies');

            if (!localStorage.getItem('cookies-accepted')) {
                banner.style.display = 'block';
            }

            acceptBtn.addEventListener('click', function() {
                localStorage.setItem('cookies-accepted', 'true');
                banner.style.display = 'none';
            });
        });
    </script>
</body>
</html>
