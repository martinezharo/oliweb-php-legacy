<?php

class Router {
    public function route($uri) {
        $uri = trim($uri, '/');
        $parts = explode('/', $uri);
        
        $lang = 'es';
        if (!empty($parts) && $parts[0] === 'en') {
            $lang = 'en';
            array_shift($parts); // Remove 'en'
        }

        // Special dynamic routes
        if (!empty($parts) && $parts[0] === 'sitemap.xml') {
            return [
                'controller' => 'SitemapController',
                'action' => 'index',
                'lang' => 'es', // Sitemap handles both langs internally
                'params' => []
            ];
        }

        // Default route (Home)
        if (empty($parts) || (count($parts) === 1 && $parts[0] === '')) {
            return [
                'controller' => 'PageController',
                'action' => 'home',
                'lang' => $lang,
                'params' => []
            ];
        }

        $section = $parts[0];
        
        // Check specific sections
        switch ($section) {
            case 'blog':
                if (isset($parts[1])) {
                    return [
                        'controller' => 'ArticleController',
                        'action' => 'show',
                        'lang' => $lang,
                        'params' => ['slug' => $parts[1]]
                    ];
                }
                break;
            case 'projects':
                if (isset($parts[1])) {
                    return [
                        'controller' => 'ProjectController',
                        'action' => 'show',
                        'lang' => $lang,
                        'params' => ['slug' => $parts[1]]
                    ];
                }
                break;
            case 'practice':
                if (isset($parts[1])) {
                    return [
                        'controller' => 'PracticeController',
                        'action' => 'show',
                        'lang' => $lang,
                        'params' => ['slug' => $parts[1]]
                    ];
                }
                break;
        }

        // Fallback to generic page
        return [
            'controller' => 'PageController',
            'action' => 'show',
            'lang' => $lang,
            'params' => ['slug' => $section]
        ];
    }
}
