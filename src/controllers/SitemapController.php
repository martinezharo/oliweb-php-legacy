<?php

class SitemapController extends BaseController {
    public function index() {
        header('Content-Type: application/xml; charset=utf-8');

        $baseUrl = "https://olivermartinezharo.com";
        $urls = [];

        // 1. Static/Main Pages
        $stmt = $this->db->prepare("SELECT slug_es, slug_en, updated_at FROM pages");
        $stmt->execute();
        $pages = $stmt->fetchAll();

        foreach ($pages as $page) {
            // Spanish version
            $slugEs = $page['slug_es'];
            $urlEs = $slugEs === 'inicio' ? $baseUrl . "/" : $baseUrl . "/" . $slugEs;
            $urls[] = [
                'loc' => $urlEs,
                'lastmod' => date('Y-m-d', strtotime($page['updated_at'])),
                'priority' => ($slugEs === 'inicio' ? '1.0' : '0.8')
            ];

            // English version
            $slugEn = $page['slug_en'];
            $urlEn = $slugEn === 'home' ? $baseUrl . "/en/" : $baseUrl . "/en/" . $slugEn;
            $urls[] = [
                'loc' => $urlEn,
                'lastmod' => date('Y-m-d', strtotime($page['updated_at'])),
                'priority' => ($slugEn === 'home' ? '1.0' : '0.8')
            ];
        }

        // 2. Blog Articles
        $stmt = $this->db->prepare("SELECT slug_es, slug_en, updated_at FROM articles");
        $stmt->execute();
        $articles = $stmt->fetchAll();

        foreach ($articles as $article) {
            $urls[] = [
                'loc' => $baseUrl . "/blog/" . $article['slug_es'],
                'lastmod' => date('Y-m-d', strtotime($article['updated_at'])),
                'priority' => '0.7'
            ];
            $urls[] = [
                'loc' => $baseUrl . "/en/blog/" . $article['slug_en'],
                'lastmod' => date('Y-m-d', strtotime($article['updated_at'])),
                'priority' => '0.7'
            ];
        }

        // 3. Projects
        $stmt = $this->db->prepare("SELECT slug_es, slug_en, updated_at FROM projects");
        $stmt->execute();
        $projects = $stmt->fetchAll();

        foreach ($projects as $project) {
            $urls[] = [
                'loc' => $baseUrl . "/projects/" . $project['slug_es'],
                'lastmod' => date('Y-m-d', strtotime($project['updated_at'])),
                'priority' => '0.6'
            ];
            $urls[] = [
                'loc' => $baseUrl . "/en/projects/" . $project['slug_en'],
                'lastmod' => date('Y-m-d', strtotime($project['updated_at'])),
                'priority' => '0.6'
            ];
        }

        // Output XML
        echo '<?xml version="1.0" encoding="UTF-8"?>';
        echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';
        foreach ($urls as $url) {
            echo '<url>';
            echo '<loc>' . htmlspecialchars($url['loc']) . '</loc>';
            echo '<lastmod>' . $url['lastmod'] . '</lastmod>';
            echo '<priority>' . $url['priority'] . '</priority>';
            echo '</url>';
        }
        echo '</urlset>';
        exit;
    }
}
