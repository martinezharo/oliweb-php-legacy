<?php

abstract class BaseController {
    protected $db;
    protected $lang;

    public function __construct($lang = 'es') {
        $this->db = Database::getInstance()->getConnection();
        $this->lang = $lang;
    }

    protected function render($view, $data = []) {
        // Extract data to variables
        extract($data);
        
        // Add lang to data
        $lang = $this->lang;
        
        // Fetch menu items for sidebar
        $menuItems = $this->getMenuItems();
        
        // Fetch footer items
        $footerPages = $this->getFooterPages();
        $activeProjects = $this->getActiveProjects();

        // Start buffering
        ob_start();
        
        // Include the view part (content)
        $viewFile = __DIR__ . '/../../templates/' . $view . '.php';
        if (file_exists($viewFile)) {
            require $viewFile;
        } else {
            echo "View not found: $view";
        }
        
        $content = ob_get_clean();
        
        // Include the main layout
        require __DIR__ . '/../../templates/layout.php';
    }

    protected function getMenuItems() {
        $stmt = $this->db->prepare("SELECT id, title_$this->lang as title, slug_$this->lang as slug FROM pages WHERE show_in_aside = 1 ORDER BY aside_order ASC");
        $stmt->execute();
        return $stmt->fetchAll();
    }

    protected function getFooterPages() {
        $stmt = $this->db->prepare("SELECT id, title_$this->lang as title, slug_$this->lang as slug FROM pages WHERE show_in_aside = 0 ORDER BY id ASC");
        $stmt->execute();
        return $stmt->fetchAll();
    }

    protected function getActiveProjects() {
        $stmt = $this->db->prepare("SELECT name_$this->lang as name, url FROM projects WHERE status = 'Current Projects' AND url IS NOT NULL AND url != '' ORDER BY created_at DESC");
        $stmt->execute();
        return $stmt->fetchAll();
    }

    protected function fixContentPaths($content) {
        $content = str_replace('src="images/', 'src="/assets/images/', $content);
        $content = str_replace('src="../../../assets/', 'src="/assets/', $content);
        $content = str_replace('src="../../assets/', 'src="/assets/', $content);
        $content = str_replace('src="../assets/', 'src="/assets/', $content);
        return $content;
    }
}
