<?php

class PageController extends BaseController {

    public function home() {
        // Fetch page with lowest ID
        $stmt = $this->db->prepare("SELECT * FROM pages ORDER BY id ASC LIMIT 1");
        $stmt->execute();
        $page = $stmt->fetch();

        if (!$page) {
            echo "No pages found.";
            return;
        }

        $this->renderPage($page);
    }

    public function show($slug) {
        $stmt = $this->db->prepare("SELECT * FROM pages WHERE slug_" . $this->lang . " = ?");
        $stmt->execute([$slug]);
        $page = $stmt->fetch();

        if (!$page) {
            http_response_code(404);
            $this->render('404', ['title' => '404 Not Found']);
            return;
        }

        $this->renderPage($page);
    }

    private function renderPage($page) {
        $title = $page['title_' . $this->lang];
        $content = $this->fixContentPaths($page['content_' . $this->lang]);
        $meta_title = $page['meta_title_' . $this->lang] ?? $title;
        $meta_desc = $page['meta_desc_' . $this->lang] ?? '';

        // Calculate alternate URL
        $alternate_lang = $this->lang == 'es' ? 'en' : 'es';
        $alternate_slug = $page['slug_' . $alternate_lang];
        
        // Handle Home special case
        if ($alternate_slug == 'home' || $alternate_slug == 'inicio') {
            $alternate_url = $alternate_lang == 'en' ? '/en/' : '/';
        } else {
            $alternate_url = ($alternate_lang == 'en' ? '/en/' : '/') . $alternate_slug;
        }

        $this->render('page', [
            'page' => $page,
            'title' => $title,
            'content' => $content,
            'meta_title' => $meta_title,
            'meta_desc' => $meta_desc,
            'alternate_url' => $alternate_url
        ]);
    }
}
