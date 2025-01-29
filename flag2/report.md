# Exposition d'un dossier caché référencé dans `robot.txt`

## Description

Le fichier `robot.txt` indique aux moteurs de recherche les parties du site à ne pas indexer. \
Mais il peut par là-même révéler des chemins confidentiels.

Ici, `robot.txt` mentionne un dossier `.hidden`. Ce dossier contenait plus de 3000 fichiers et dossiers. \
L'un de ces fichiers contenait le flag.

## Step to reproduce

1. Télécharger l'intégralité du dossier caché en ignorant les règles de `robot.txt`:
```
wget -e robots=off -r --no-parent http://192.168.56.101/.hidden/
```

2. Chercher tous les fichiers README et extraire leur contenu :
```
find . -name 'README' -print -exec cat {} >> readme.txt ; -exec echo ;
```

3.	Chercher "flag" dans le fichier.
```
Hey, here is your flag : d5eec3ec36cf80dce44a896f961c1831a05526ec215693c8f2c39543497d4466
```

## Danger

• **Exposition d’informations sensibles** : Un attaquant peut découvrir des dossiers cachés et extraire des données confidentielles.
• **Risque d’indexation malveillante** : Même si robots.txt interdit l’indexation, il est souvent analysé par des attaquants pour identifier des fichiers cachés.
• **Brute-force facilité** : Un dossier contenant des milliers de fichiers avec des noms aléatoires peut être exploré automatiquement via des outils comme wget ou dirb.

## Recommanded fix

1. Ne pas exposer d’informations sensibles dans robots.txt : Éviter d’y mentionner des chemins qui ne doivent pas être accessibles.

2. Restreindre l’accès via configuration serveur :

• Sur Apache, ajouter une règle dans .htaccess pour interdire l’accès au dossier :

```
<Directory "/var/www/html/.hidden">
    Order Allow,Deny
    Deny from all
</Directory>
```

• Sur Nginx, bloquer l’accès via nginx.conf :

```
location /.hidden {
    deny all;
    return 403;
}
```

3. Utiliser un mécanisme d’authentification : Protéger les dossiers sensibles par une authentification (.htpasswd, JWT, sessions).

