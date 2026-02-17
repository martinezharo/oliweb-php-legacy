<?php

class PracticeController extends BaseController {

    public function show($slug) {
        $stmt = $this->db->prepare("SELECT * FROM practice_projects WHERE slug_" . $this->lang . " = ?");
        $stmt->execute([$slug]);
        $project = $stmt->fetch();

        if (!$project) {
            http_response_code(404);
            $this->render('404', ['title' => '404 Not Found']);
            return;
        }

        $title = $project['name_' . $this->lang];
        $content = $this->fixContentPaths($project['description_' . $this->lang]);
        $url = $project['url'];
        $image = $project['image_path'];

        // Check if URL is a local folder in practice-projects
        $is_local = false;
        $launch_url = $url;
        if ($url && !filter_var($url, FILTER_VALIDATE_URL)) {
            // Assume it's a folder name
            $is_local = true;
            $launch_url = '/practice-projects/' . $url . '/index.html';
            
            // Fix image path if it's relative
            if ($image && strpos($image, '/') === false) {
                $image = '/practice-projects/' . $url . '/' . $image;
            }
        }

        // Alternate URL
        $alternate_lang = $this->lang == 'es' ? 'en' : 'es';
        $alternate_slug = $project['slug_' . $alternate_lang];
        $alternate_url = ($alternate_lang == 'en' ? '/en/practice/' : '/practice/') . $alternate_slug;

        $this->render('practice', [
            'project' => $project,
            'title' => $title,
            'content' => $content,
            'launch_url' => $launch_url,
            'image' => $image,
            'alternate_url' => $alternate_url
        ]);
    }
}
