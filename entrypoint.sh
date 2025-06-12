#!/bin/sh

echo "⏳ Pause de 10 secondes avant de lancer les migrations..."
sleep 5

echo "✅ Lancement des migrations..."
php artisan migrate --force

echo "🚀 Démarrage d'Apache..."
exec apache2-foreground

