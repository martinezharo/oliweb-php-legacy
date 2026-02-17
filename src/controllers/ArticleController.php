<?php

class ArticleController extends BaseController {

    public function show($slug) {
        $stmt = $this->db->prepare("SELECT * FROM articles WHERE slug_" . $this->lang . " = ?");
        $stmt->execute([$slug]);
        $article = $stmt->fetch();

        if (!$article) {
            http_response_code(404);
            $this->render('404', ['title' => '404 Not Found']);
            return;
        }

        $title = $article['title_' . $this->lang];
        $content = $this->fixContentPaths($article['content_' . $this->lang]);
        $meta_title = $article['meta_title_' . $this->lang] ?? $title;
        $meta_desc = $article['meta_desc_' . $this->lang] ?? '';
        $date = $article['created_at'];

        // Alternate URL
        $alternate_lang = $this->lang == 'es' ? 'en' : 'es';
        $alternate_slug = $article['slug_' . $alternate_lang];
        $alternate_url = ($alternate_lang == 'en' ? '/en/blog/' : '/blog/') . $alternate_slug;

        $this->render('article', [
            'article' => $article,
            'title' => $title,
            'content' => $content,
            'meta_title' => $meta_title,
            'meta_desc' => $meta_desc,
            'date' => $date,
            'alternate_url' => $alternate_url
        ]);
    }
}
