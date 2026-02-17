<?php

class ProjectController extends BaseController {

    public function show($slug) {
        $stmt = $this->db->prepare("SELECT * FROM projects WHERE slug_" . $this->lang . " = ?");
        $stmt->execute([$slug]);
        $project = $stmt->fetch();

        if (!$project) {
            http_response_code(404);
            $this->render('404', ['title' => '404 Not Found']);
            return;
        }

        $title = $project['name_' . $this->lang];
        $content = $project['description_' . $this->lang];
        $meta_title = $project['meta_title_' . $this->lang] ?? $title;
        $meta_desc = $project['meta_desc_' . $this->lang] ?? '';
        $url = $project['url'];
        $logo = $project['logo_path'];
        
        // Fix logo path if it starts with images/
        if (strpos($logo, 'images/') === 0) {
            $logo = '/assets/' . $logo;
        }

        // Fix images in content
        $content = $this->fixContentPaths($content);

        // Alternate URL
        $alternate_lang = $this->lang == 'es' ? 'en' : 'es';
        $alternate_slug = $project['slug_' . $alternate_lang];
        $alternate_url = ($alternate_lang == 'en' ? '/en/projects/' : '/projects/') . $alternate_slug;

        $this->render('project', [
            'project' => $project,
            'title' => $title,
            'content' => $content,
            'meta_title' => $meta_title,
            'meta_desc' => $meta_desc,
            'url' => $url,
            'logo' => $logo,
            'alternate_url' => $alternate_url
        ]);
    }
}
