<?php
/**
 * Configuration WordPress générée automatiquement
 */

// Configuration de la base de données
define('DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wordpress');
define('DB_USER', getenv('WORDPRESS_DB_USER') ?: 'wpuser');
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'wppassword');
define('DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'mariadb:3306');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

// Clés de sécurité WordPress
define('AUTH_KEY',         'SECURE_AUTH_KEY_HERE');
define('SECURE_AUTH_KEY',  'SECURE_AUTH_KEY_HERE');
define('LOGGED_IN_KEY',    'LOGGED_IN_KEY_HERE');
define('NONCE_KEY',        'NONCE_KEY_HERE');
define('AUTH_SALT',        'AUTH_SALT_HERE');
define('SECURE_AUTH_SALT', 'SECURE_AUTH_SALT_HERE');
define('LOGGED_IN_SALT',   'LOGGED_IN_SALT_HERE');
define('NONCE_SALT',       'NONCE_SALT_HERE');

// Préfixe de table
$table_prefix = getenv('WORDPRESS_TABLE_PREFIX') ?: 'wp_';

// Configuration du debug
define('WP_DEBUG', false);
define('WP_DEBUG_LOG', false);
define('WP_DEBUG_DISPLAY', false);

// Configuration des URL
define('WP_HOME', getenv('WORDPRESS_URL') ?: 'https://localhost');
define('WP_SITEURL', getenv('WORDPRESS_URL') ?: 'https://localhost');

// Configuration des mises à jour automatiques
define('AUTOMATIC_UPDATER_DISABLED', true);
define('WP_AUTO_UPDATE_CORE', false);

// Configuration des révisions
define('WP_POST_REVISIONS', 3);

// Configuration du cache
define('WP_CACHE', false);

// Configuration des uploads
define('UPLOADS', 'wp-content/uploads');

// Configuration SSL
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

// Configuration multisite (désactivé par défaut)
define('WP_ALLOW_MULTISITE', false);

// Configuration des permissions de fichiers
define('FS_METHOD', 'direct');
define('FS_CHMOD_DIR', (0755 & ~ umask()));
define('FS_CHMOD_FILE', (0644 & ~ umask()));

// Configuration de la mémoire
define('WP_MEMORY_LIMIT', '256M');

// Configuration des cookies
define('COOKIE_DOMAIN', '');

// Fin de la configuration
if (!defined('ABSPATH')) {
    define('ABSPATH', dirname(__FILE__) . '/');
}

require_once(ABSPATH . 'wp-settings.php');
?>
