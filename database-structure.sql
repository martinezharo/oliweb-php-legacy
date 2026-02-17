
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarContenidoBlog` ()   BEGIN
    DECLARE html_home_es LONGTEXT DEFAULT '';
    DECLARE html_home_en LONGTEXT DEFAULT '';
    DECLARE html_full_es LONGTEXT DEFAULT '';
    DECLARE html_full_en LONGTEXT DEFAULT '';

    SET SESSION group_concat_max_len = 1000000;

    -- A) HTML para HOME (Últimos 4 artículos)
    SELECT GROUP_CONCAT(
        CONCAT(
            '<div class="blog-card card">',
            '<a href="/blog/', slug_es, '" class="card-link">',
            '<h3 class="blog-title">', title_es, '</h3>',
            '<p class="blog-date">', DATE_FORMAT(created_at, '%d/%m/%Y'), '</p>',
            '<p class="blog-text">', IFNULL(meta_desc_es, ''), '</p>',
            '<span class="view-all">Ver Más</span>',
            '</a>',
            '</div>'
        ) ORDER BY created_at DESC SEPARATOR '\n'
    ) INTO html_home_es FROM (SELECT * FROM articles ORDER BY created_at DESC LIMIT 4) AS t;

    SELECT GROUP_CONCAT(
        CONCAT(
            '<div class="blog-card card">',
            '<a href="/en/blog/', slug_en, '" class="card-link">',
            '<h3 class="blog-title">', title_en, '</h3>',
            '<p class="blog-date">', DATE_FORMAT(created_at, '%M %d, %Y'), '</p>',
            '<p class="blog-text">', IFNULL(meta_desc_en, ''), '</p>',
            '<span class="view-all">View More</span>',
            '</a>',
            '</div>'
        ) ORDER BY created_at DESC SEPARATOR '\n'
    ) INTO html_home_en FROM (SELECT * FROM articles ORDER BY created_at DESC LIMIT 4) AS t_en;

    -- B) HTML para PÁGINA BLOG (Todos los artículos)
    SELECT GROUP_CONCAT(
        CONCAT(
            '<div class="blog-card card">',
            '<a href="/blog/', slug_es, '" class="card-link">',
            '<h3 class="blog-title">', title_es, '</h3>',
            '<p class="blog-date">', DATE_FORMAT(created_at, '%d/%m/%Y'), '</p>',
            '<p class="blog-text">', IFNULL(meta_desc_es, ''), '</p>',
            '<span class="view-all">Ver Más</span>',
            '</a>',
            '</div>'
        ) ORDER BY created_at DESC SEPARATOR '\n'
    ) INTO html_full_es FROM articles;

    SELECT GROUP_CONCAT(
        CONCAT(
            '<div class="blog-card card">',
            '<a href="/en/blog/', slug_en, '" class="card-link">',
            '<h3 class="blog-title">', title_en, '</h3>',
            '<p class="blog-date">', DATE_FORMAT(created_at, '%M %d, %Y'), '</p>',
            '<p class="blog-text">', IFNULL(meta_desc_en, ''), '</p>',
            '<span class="view-all">View More</span>',
            '</a>',
            '</div>'
        ) ORDER BY created_at DESC SEPARATOR '\n'
    ) INTO html_full_en FROM articles;

    -- C) Actualizar HOME (ID: 1)
    UPDATE pages SET 
        content_es = CONCAT(SUBSTRING_INDEX(content_es, '<!-- ARTICLES_START -->', 1), '<!-- ARTICLES_START -->\n', IFNULL(html_home_es, ''), '\n<!-- ARTICLES_END -->', SUBSTRING_INDEX(content_es, '<!-- ARTICLES_END -->', -1)),
        content_en = CONCAT(SUBSTRING_INDEX(content_en, '<!-- ARTICLES_START -->', 1), '<!-- ARTICLES_START -->\n', IFNULL(html_home_en, ''), '\n<!-- ARTICLES_END -->', SUBSTRING_INDEX(content_en, '<!-- ARTICLES_END -->', -1))
    WHERE id = 1;

    -- D) Actualizar PÁGINA BLOG (ID: 6)
    UPDATE pages SET 
        content_es = CONCAT(SUBSTRING_INDEX(content_es, '<!-- ARTICLES_START -->', 1), '<!-- ARTICLES_START -->\n', IFNULL(html_full_es, ''), '\n<!-- ARTICLES_END -->', SUBSTRING_INDEX(content_es, '<!-- ARTICLES_END -->', -1)),
        content_en = CONCAT(SUBSTRING_INDEX(content_en, '<!-- ARTICLES_START -->', 1), '<!-- ARTICLES_START -->\n', IFNULL(html_full_en, ''), '\n<!-- ARTICLES_END -->', SUBSTRING_INDEX(content_en, '<!-- ARTICLES_END -->', -1))
    WHERE id = 6;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarHomeDinamica` ()   BEGIN
    -- Esta lógica parece duplicada o similar a la anterior, pero respetamos la estructura original mejorando el HTML si es necesario.
    -- En este caso, simplemente llamamos a ActualizarContenidoBlog que ya maneja la home.
    CALL ActualizarContenidoBlog();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarPaginaPracticas` ()   BEGIN
    DECLARE html_practicas_es LONGTEXT DEFAULT '';
    DECLARE html_practicas_en LONGTEXT DEFAULT '';

    SET SESSION group_concat_max_len = 1000000;

    -- Generar HTML en ESPAÑOL
    SELECT GROUP_CONCAT(
        CONCAT(
            '<div class="practice-project-card card">',
            '<a href="/practice-projects/', IFNULL(url, ''), '/index.html" class="card-link" target="_blank">',
            '<h2 class="practice-project-name">', name_es, '</h2>',
            IF(image_path IS NOT NULL AND image_path != '', 
               CONCAT('<img src="/practice-projects/', IFNULL(url, ''), '/', image_path, '" class="practice-project-thumbnail" alt="', name_es, '" loading="lazy">'), 
               ''),
            '<p class="url-or-activity-date">', IFNULL(url, ''), '</p>',
            '<div class="practice-project-text">', description_es, '</div>',
            '<span class="view-all">Ver Práctica</span>',
            '</a>',
            '</div>'
        ) ORDER BY created_at DESC SEPARATOR '\n'
    ) INTO html_practicas_es FROM practice_projects;

    -- Generar HTML en INGLÉS
    SELECT GROUP_CONCAT(
        CONCAT(
            '<div class="practice-project-card card">',
            '<a href="/practice-projects/', IFNULL(url, ''), '/index.html" class="card-link" target="_blank">',
            '<h2 class="practice-project-name">', name_en, '</h2>',
            IF(image_path IS NOT NULL AND image_path != '', 
               CONCAT('<img src="/practice-projects/', IFNULL(url, ''), '/', image_path, '" class="practice-project-thumbnail" alt="', name_en, '" loading="lazy">'), 
               ''),
            '<p class="url-or-activity-date">', IFNULL(url, ''), '</p>',
            '<div class="practice-project-text">', description_en, '</div>',
            '<span class="view-all">View Practice</span>',
            '</a>',
            '</div>'
        ) ORDER BY created_at DESC SEPARATOR '\n'
    ) INTO html_practicas_en FROM practice_projects;

    -- Inyectar en la página ID 10
    UPDATE pages SET 
        content_es = CONCAT(
            SUBSTRING_INDEX(content_es, '<!-- PRACTICE_START -->', 1), 
            '<!-- PRACTICE_START -->\n', 
            IFNULL(html_practicas_es, ''), 
            '\n<!-- PRACTICE_END -->', 
            SUBSTRING_INDEX(content_es, '<!-- PRACTICE_END -->', -1)
        ),
        content_en = CONCAT(
            SUBSTRING_INDEX(content_en, '<!-- PRACTICE_START -->', 1), 
            '<!-- PRACTICE_START -->\n', 
            IFNULL(html_practicas_en, ''), 
            '\n<!-- PRACTICE_END -->', 
            SUBSTRING_INDEX(content_en, '<!-- PRACTICE_END -->', -1)
        )
    WHERE id = 10;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarPaginasProyectos` ()   BEGIN
    DECLARE html_actuales_es LONGTEXT DEFAULT '';
    DECLARE html_actuales_en LONGTEXT DEFAULT '';
    DECLARE html_pasados_es LONGTEXT DEFAULT '';
    DECLARE html_pasados_en LONGTEXT DEFAULT '';

    SET SESSION group_concat_max_len = 1000000;

    -- A) Proyectos Actuales (ID: 4)
    SELECT GROUP_CONCAT(
        CONCAT(
            '<div class="project-card card">',
            '<a href="/projects/', slug_es, '" class="card-link">',
            '<h2 class="project-name">', name_es, '</h2>',
            IF(logo_path IS NOT NULL AND logo_path != '', CONCAT('<img src="', logo_path, '" class="project-logo" alt="', name_es, '" loading="lazy">'), ''),
            '<p class="url-or-activity-date">', IFNULL(url, ''), '</p>',
            '<div class="project-text">', description_es, '</div>',
            '<span class="view-all">Ver Proyecto</span>',
            '</a>',
            '</div>'
        ) ORDER BY created_at DESC SEPARATOR '\n'
    ) INTO html_actuales_es FROM projects WHERE status = 'Current Projects';

    SELECT GROUP_CONCAT(
        CONCAT(
            '<div class="project-card card">',
            '<a href="/en/projects/', slug_en, '" class="card-link">',
            '<h2 class="project-name">', name_en, '</h2>',
            IF(logo_path IS NOT NULL AND logo_path != '', CONCAT('<img src="', logo_path, '" class="project-logo" alt="', name_en, '" loading="lazy">'), ''),
            '<p class="url-or-activity-date">', IFNULL(url, ''), '</p>',
            '<div class="project-text">', description_en, '</div>',
            '<span class="view-all">View Project</span>',
            '</a>',
            '</div>'
        ) ORDER BY created_at DESC SEPARATOR '\n'
    ) INTO html_actuales_en FROM projects WHERE status = 'Current Projects';

    -- B) Proyectos Pasados (ID: 5)
    SELECT GROUP_CONCAT(
        CONCAT(
            '<div class="project-card card">',
            '<a href="/projects/', slug_es, '" class="card-link">',
            '<h2 class="project-name">', name_es, '</h2>',
            IF(logo_path IS NOT NULL AND logo_path != '', CONCAT('<img src="', logo_path, '" class="project-logo" alt="', name_es, '" loading="lazy">'), ''),
            '<p class="url-or-activity-date">', IFNULL(activity_date, ''), '</p>',
            '<div class="project-text">', description_es, '</div>',
            '<span class="view-all">Ver Proyecto</span>',
            '</a>',
            '</div>'
        ) ORDER BY created_at DESC SEPARATOR '\n'
    ) INTO html_pasados_es FROM projects WHERE status = 'Past Projects';

    SELECT GROUP_CONCAT(
        CONCAT(
            '<div class="project-card card">',
            '<a href="/en/projects/', slug_en, '" class="card-link">',
            '<h2 class="project-name">', name_en, '</h2>',
            IF(logo_path IS NOT NULL AND logo_path != '', CONCAT('<img src="', logo_path, '" class="project-logo" alt="', name_en, '" loading="lazy">'), ''),
            '<p class="url-or-activity-date">', IFNULL(activity_date, ''), '</p>',
            '<div class="project-text">', description_en, '</div>',
            '<span class="view-all">View Project</span>',
            '</a>',
            '</div>'
        ) ORDER BY created_at DESC SEPARATOR '\n'
    ) INTO html_pasados_en FROM projects WHERE status = 'Past Projects';

    -- C) Inyección en la Tabla Pages
    UPDATE pages SET 
        content_es = CONCAT(SUBSTRING_INDEX(content_es, '<!-- PROJECTS_START -->', 1), '<!-- PROJECTS_START -->\n', IFNULL(html_actuales_es, ''), '\n<!-- PROJECTS_END -->', SUBSTRING_INDEX(content_es, '<!-- PROJECTS_END -->', -1)),
        content_en = CONCAT(SUBSTRING_INDEX(content_en, '<!-- PROJECTS_START -->', 1), '<!-- PROJECTS_START -->\n', IFNULL(html_actuales_en, ''), '\n<!-- PROJECTS_END -->', SUBSTRING_INDEX(content_en, '<!-- PROJECTS_END -->', -1))
    WHERE id = 4;

    UPDATE pages SET 
        content_es = CONCAT(SUBSTRING_INDEX(content_es, '<!-- PROJECTS_START -->', 1), '<!-- PROJECTS_START -->\n', IFNULL(html_pasados_es, ''), '\n<!-- PROJECTS_END -->', SUBSTRING_INDEX(content_es, '<!-- PROJECTS_END -->', -1)),
        content_en = CONCAT(SUBSTRING_INDEX(content_en, '<!-- PROJECTS_START -->', 1), '<!-- PROJECTS_START -->\n', IFNULL(html_pasados_en, ''), '\n<!-- PROJECTS_END -->', SUBSTRING_INDEX(content_en, '<!-- PROJECTS_END -->', -1))
    WHERE id = 5;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `id` int NOT NULL,
  `title_es` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title_en` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug_es` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug_en` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_es` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_en` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_title_es` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_title_en` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_desc_es` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_desc_en` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `articles`
--
DELIMITER $$
CREATE TRIGGER `tr_articles_delete` AFTER DELETE ON `articles` FOR EACH ROW BEGIN CALL ActualizarContenidoBlog(); END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_articles_insert` AFTER INSERT ON `articles` FOR EACH ROW BEGIN CALL ActualizarContenidoBlog(); END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_articles_update` AFTER UPDATE ON `articles` FOR EACH ROW BEGIN CALL ActualizarContenidoBlog(); END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE `pages` (
  `id` int NOT NULL,
  `title_es` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title_en` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug_es` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug_en` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_es` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_en` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_title_es` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_title_en` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_desc_es` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_desc_en` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `show_in_aside` tinyint(1) NOT NULL DEFAULT '1',
  `aside_order` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `practice_projects`
--

CREATE TABLE `practice_projects` (
  `id` int NOT NULL,
  `name_es` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug_es` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug_en` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_es` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `description_en` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `practice_projects`
--
DELIMITER $$
CREATE TRIGGER `tr_practice_projects_delete` AFTER DELETE ON `practice_projects` FOR EACH ROW BEGIN CALL ActualizarPaginaPracticas(); END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_practice_projects_insert` AFTER INSERT ON `practice_projects` FOR EACH ROW BEGIN CALL ActualizarPaginaPracticas(); END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_practice_projects_update` AFTER UPDATE ON `practice_projects` FOR EACH ROW BEGIN CALL ActualizarPaginaPracticas(); END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `id` int NOT NULL,
  `name_es` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug_es` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug_en` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activity_date` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_es` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `description_en` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('Past Projects','Current Projects') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Current Projects',
  `meta_title_es` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_title_en` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_desc_es` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_desc_en` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `name_es`, `name_en`, `slug_es`, `slug_en`, `url`, `activity_date`, `logo_path`, `description_es`, `description_en`, `status`, `meta_title_es`, `meta_title_en`, `meta_desc_es`, `meta_desc_en`, `created_at`, `updated_at`) VALUES
(1, 'RANKMAKER', 'RANKMAKER', 'rankmaker', 'rankmaker', 'https://rankmaker.net', NULL, 'images/rankmaker-logo.png', '<p>RANKMAKER es una plataforma web que permite a los usuarios crear rankings a trav&eacute;s de batallas 1vs1. Me tomo meses de desarrollo para algo que cre&iacute;a que ser&iacute;a un par de d&iacute;as con IA. Comenc&eacute; sin conocimientos de programaci&oacute;n, y el proceso estuvo lleno de contratiempos, retrasos y reinicios. Pero el 6 de junio de 2025, RANKMAKER finalmente fue publicado.</p>', '<p>RANKMAKER is a web platform that lets users create rankings through automated 1vs1 battles. It took months of intense development. I started with zero programming knowledge, and the process was full of setbacks, delays, and restarts. But on June 6th, 2025, RANKMAKER officially went live.</p>', 'Current Projects', 'RANKMAKER - Proyecto de Oliver Martínez Haro', 'RANKMAKER - Oliver Martínez Haro Project', 'RANKMAKER es una plataforma web innovadora para crear rankings a través de batallas 1vs1. Desarrollado por Oliver Martínez Haro.', 'RANKMAKER is an innovative web platform for creating rankings through 1vs1 battles. Developed by Oliver Martínez Haro.', '2025-08-01 19:42:23', '2025-08-03 17:07:41'),
(2, 'Octopus Control', 'Octopus Control', 'octopuscontrol', 'octopuscontrol', 'https://octopuscontrol.com', '<br /><b>Deprecated</b>:  htmlspecialchars(): Passing null to parameter #1 ($string) of type string is deprecated in <b>C:\\Users\\PC\\olivermartinezharo\\public_html\\cms\\admin\\projects\\edit.php</b> on line <b>60</b><br />', 'images/octopuscontrol-logo.jpg', '<p>Octopus Control es una tienda online espa&ntilde;ola que vende mandos de TV compatibles (no universales). Se lanz&oacute; en julio de 2024. Originalmente, el objetivo no era vender mandos. Solo quer&iacute;a comprar productos nuevos al por mayor y revenderlos en plataformas de segunda mano como Wallapop pero los mandos siempre fue lo principal aunque no me especialic&eacute; completamente en ellos hasta unos meses despu&eacute;s.</p>\r\n<p>El mayor contratiempo lleg&oacute; en octubre de 2023, cuando mi cuenta de Wallapop fue suspendida durante dos semanas. Luch&eacute; mucho para recuperarla, y lo logr&eacute;. Despu&eacute;s de eso, Octopus Control se expandi&oacute; a otras plataformas y lanz&oacute; su propio sitio web. Hasta ahora, es mi proyecto m&aacute;s rentable y exitoso.</p>', '<p data-start=\"0\" data-end=\"379\">Octopus Control is a Spanish online store that sells compatible (non-universal) TV remotes. It was launched in July 2024. Originally, the goal wasn&rsquo;t to sell remotes &mdash; I just wanted to buy new products wholesale and resell them on second-hand platforms like Wallapop, but remotes were always the main focus, even though I didn&rsquo;t fully specialise in them until a few months later.</p>\r\n<p>&nbsp;</p>\r\n<p data-start=\"381\" data-end=\"661\" data-is-last-node=\"\" data-is-only-node=\"\">The biggest setback came in October 2023, when my Wallapop account was suspended for two weeks. I fought hard to get it back &mdash; and I did. After that, Octopus Control expanded to other platforms and launched its own website. So far, it is my most profitable and successful project.</p>', 'Current Projects', 'Octopus Control - Proyecto de Oliver Martínez Haro', 'Octopus Control - Oliver Martínez Haro Project', 'Octopus Control es una tienda online española especializada en mandos de TV compatibles.', 'Octopus Control is a Spanish online store specialized in compatible TV remotes. ', '2025-08-01 19:42:23', '2025-08-03 18:29:46'),
(3, 'EliteBara', 'EliteBara', 'elitebara', 'elitebara', NULL, '2023-2023', 'images/elitebara-logo.jpg', '<p data-start=\"0\" data-end=\"225\">EliteBara fue una tienda online de corta duraci&oacute;n que vend&iacute;a ropa con dise&ntilde;os de capibaras mediante impresi&oacute;n bajo demanda. Financiera&shy;mente, fue un fracaso total, pero desde el punto de vista del aprendizaje, fue invaluable.</p>\r\n<p data-start=\"227\" data-end=\"510\">Todo empez&oacute; con un sorteo para promocionar la tienda, que apenas atrajo a dos o tres participantes. Los esfuerzos de marketing posteriores se centraron en v&iacute;deos cortos para redes sociales. Aunque los v&iacute;deos funcionaron decentemente gracias a su absurdo, eso no se tradujo en ventas.</p>\r\n<p data-start=\"512\" data-end=\"560\" data-is-last-node=\"\" data-is-only-node=\"\">EliteBara recibi&oacute; solo un pedido: dos camisetas.</p>', '<p>EliteBara was a short-lived online store that sold clothes featuring capybara designs through print-on-demand. Financially, it was a total failure &mdash; but from a learning perspective, it was invaluable.</p>\r\n<p>It all started with a giveaway to promote the store, which barely attracted two or three participants. The following marketing efforts focused on short-form videos for social media. While the videos performed decently thanks to their absurdity, that didn\'t translate into sales.</p>\r\n<p>EliteBara received just one order &mdash; two T-shirts.</p>', 'Past Projects', 'EliteBara - Proyecto Pasado de Oliver Martínez Haro', 'EliteBara - Past Project by Oliver Martínez Haro', 'EliteBara fue una tienda online de corta duración que vendía ropa con diseños de capibaras mediante impresión bajo demanda. ', 'EliteBara was a short-lived online store that sold clothes featuring capybara designs through print-on-demand.', '2025-08-01 19:42:23', '2025-08-03 18:23:15'),
(4, 'Kenobismo', 'Kenobismo', 'kenobismo', 'kenobismo', NULL, '2020-2023', 'images/kenobismo-logo.jpg', '<p data-start=\"0\" data-end=\"92\">Kenobismo fue un proyecto en redes sociales centrado en datos, lore y noticias de Star Wars.</p>\r\n<p data-start=\"94\" data-end=\"456\">Comenz&oacute; como una &uacute;nica cuenta de Instagram. Inicialmente, tambi&eacute;n plane&eacute; publicar contenido de Marvel, pero solo hice tres publicaciones al respecto antes de abandonar esa idea. La estrategia de crecimiento era simple: seguir masivamente cuentas de fans similares con la esperanza de que me siguieran de vuelta. Funcion&oacute;. Kenobismo gan&oacute; miles de seguidores as&iacute;.</p>\r\n<p data-start=\"458\" data-end=\"684\">Meses despues, hice una pausa que se supon&iacute;a ser&iacute;a corta, pero termin&oacute; durando m&aacute;s de un a&ntilde;o. Cuando volv&iacute;, me lanc&eacute; de lleno, empec&eacute; a publicar v&iacute;deos cortos, no solo en Instagram, sino tambi&eacute;n en TikTok y YouTube.</p>\r\n<p data-start=\"686\" data-end=\"935\">TikTok r&aacute;pidamente super&oacute; a Instagram, y consegu&iacute; monetizar. Tras dos meses, hab&iacute;a ganado unos 60&ndash;70 &euro;. Pero entonces lleg&oacute; el shadowban: mis v&iacute;deos pasaron de tener entre 10k y 50k visualizaciones a apenas superar las 1.000, si es que lo lograban.</p>\r\n<p data-start=\"937\" data-end=\"1153\">Frustrado, cre&eacute; nuevas cuentas para publicar videos de cine en general. Sub&iacute; m&aacute;s de 100 v&iacute;deos, pero los resultados fueron mediocres. Volv&iacute; a Kenobismo y durante un tiempo mezcl&eacute; contenido de Star Wars con cine general.</p>\r\n<p>&nbsp;</p>\r\n<p data-start=\"1155\" data-end=\"1400\" data-is-last-node=\"\" data-is-only-node=\"\">Kenobismo termin&oacute; finalmente cuando consider&eacute; hacer v&iacute;deos largos en YouTube y me di cuenta de dos cosas: hab&iacute;a sobreestimado mis conocimientos de cine, y odiaba grabarme a m&iacute; mismo, necesitaba decenas de tomas para filmar apenas unos segundos.</p>', '<p>Kenobismo was a social media project focused on Star Wars facts, lore, and news.</p>\n<p>&nbsp;</p>\n<p>It started as a single Instagram account. Initially, I also planned to post Marvel content, but only made three posts about it before dropping that idea. The growth strategy was simple: mass-follow similar fan accounts hoping they\'d follow back. It worked &mdash; Kenobismo gained thousands of followers this way.</p>\n<p>&nbsp;</p>\n<p>Eventually, I took a break that was meant to be short but ended up lasting over a year. When I returned, I went all in &mdash; I began posting short videos not just on Instagram, but also on TikTok and YouTube.</p>\n<p>&nbsp;</p>\n<p>TikTok quickly overtook Instagram, and I managed to monetize. After two months, I had earned about &euro;60&ndash;70. But then came the shadowban: my videos went from pulling 10k&ndash;50k views to barely crossing 1,000 &mdash; if at all.</p>\n<p>&nbsp;</p>\n<p>Frustrated, I created new accounts to post general movie videos. I uploaded over 100 videos, but results were mediocre. I returned to Kenobismo and began mixing Star Wars and general movie content for a while.</p>\n<p>&nbsp;</p>\n<p>Kenobismo finally ended when I considered making long-form YouTube videos and realized two things: I had overestimated my knowledge of cinema, and I absolutely hated recording myself &mdash; I needed dozens of takes to film just a few seconds.</p>', 'Past Projects', 'Kenobismo - Proyecto Pasado de Oliver Martínez Haro', 'Kenobismo - Past Project by Oliver Martínez Haro', 'Kenobismo fue la cuenta de Instagram de Star Wars que marcó el inicio de la carrera emprendedora de Oliver Martínez Haro en 2020.', 'Kenobismo was the Star Wars Instagram account that marked the beginning of Oliver Martínez Haro\'s entrepreneurial career in 2020.', '2025-08-01 19:42:23', '2026-01-27 18:14:07'),
(6, 'Goal: Partner.', 'Goal: Partner.', 'GoaPartner-es', 'GoalPartner', 'https://goal-partner.com/', '2025-2025', 'images/goal-partner-logo.png', '<p><span class=\"notion-enable-hover\" style=\"font-weight: 600;\" data-token-index=\"0\">Goal: Partner</span> es la plataforma de citas que rompe con el negocio del fracaso. Sin l&iacute;mites, sin suscripciones y sin algoritmos opacos, te muestra a todas las personas compatibles contigo de forma transparente y directa, para que encuentres pareja y no tengas que seguir buscando.<!-- notionvc: 2c8a346e-90d6-4ec0-9cf9-0daed34e4ced --></p>', '<p>Goal: Partner is the dating platform that breaks away from the business of failure. No limits, no subscriptions, and no opaque algorithms &mdash; it shows you everyone compatible with you, transparently and directly, so you can find a real partner and stop searching.</p>', 'Past Projects', 'Goal: Partner.', 'Goal: Partner.', 'Goal: Partner es la plataforma de citas que rompe con el negocio del fracaso.', 'Goal: Partner is the dating platform that breaks away from the business of failure.', '2025-10-18 19:39:49', '2026-01-24 10:07:48');

--
-- Triggers `projects`
--
DELIMITER $$
CREATE TRIGGER `tr_projects_delete` AFTER DELETE ON `projects` FOR EACH ROW BEGIN CALL ActualizarPaginasProyectos(); END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_projects_insert` AFTER INSERT ON `projects` FOR EACH ROW BEGIN CALL ActualizarPaginasProyectos(); END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_projects_update` AFTER UPDATE ON `projects` FOR EACH ROW BEGIN CALL ActualizarPaginasProyectos(); END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug_es` (`slug_es`),
  ADD UNIQUE KEY `slug_en` (`slug_en`);

--
-- Indexes for table `practice_projects`
--
ALTER TABLE `practice_projects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug_es` (`slug_es`),
  ADD UNIQUE KEY `slug_en` (`slug_en`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug_es` (`slug_es`),
  ADD UNIQUE KEY `slug_en` (`slug_en`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pages`
--
ALTER TABLE `pages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `practice_projects`
--
ALTER TABLE `practice_projects`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;
