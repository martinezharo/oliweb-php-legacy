<?php
// Autoloader
spl_autoload_register(function ($class) {
    $prefix = '';
    $base_dir = __DIR__ . '/../src/';

    $len = strlen($prefix);
    if (strncmp($prefix, $class, $len) !== 0) {
        return;
    }

    $relative_class = substr($class, $len);
    
    // Check main src directory first
    $file = $base_dir . str_replace('\\', '/', $relative_class) . '.php';
    if (file_exists($file)) {
        require $file;
        return;
    }

    // Check controllers
    $file = $base_dir . 'controllers/' . str_replace('\\', '/', $relative_class) . '.php';
    if (file_exists($file)) {
        require $file;
        return;
    }
    
    // Check helpers
    $file = $base_dir . 'helpers/' . str_replace('\\', '/', $relative_class) . '.php';
    if (file_exists($file)) {
        require $file;
        return;
    }
});

require_once __DIR__ . '/../config/database.php';

$router = new Router();
$route = $router->route($_SERVER['REQUEST_URI']);

$controllerName = $route['controller'];
$actionName = $route['action'];
$params = $route['params'];
$lang = $route['lang'];

if (class_exists($controllerName)) {
    $controller = new $controllerName($lang);
    if (method_exists($controller, $actionName)) {
        call_user_func_array([$controller, $actionName], $params);
    } else {
        // Handle 404
        http_response_code(404);
        echo "404 - Action not found";
    }
} else {
    // Handle 404
    http_response_code(404);
    echo "404 - Controller not found: $controllerName";
}
