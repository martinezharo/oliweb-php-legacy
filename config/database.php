<?php
// Determine environment
$whitelist = array(
    '127.0.0.1',
    '::1',
    'localhost'
);

if(in_array($_SERVER['REMOTE_ADDR'], $whitelist)){
    // Local
    define('DB_HOST', 'localhost');
    define('DB_NAME', 'DB_NAME');
    define('DB_USER', 'DB_USER');
    define('DB_PASS', 'DB_PASS');
    define('DB_CHARSET', 'utf8mb4');
} else {
    // Production
    define('DB_HOST', 'DB_HOST');
    define('DB_NAME', 'DB_NAME');
    define('DB_USER', 'DB_USER');
    define('DB_PASS', 'DB_PASS');
    define('DB_CHARSET', 'utf8mb4');
}
?>