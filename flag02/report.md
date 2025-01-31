# Exposure of a Hidden Folder Referenced in robots.txt

## Description

The `robots.txt` file instructs search engines on which parts of the site should not be indexed. 
However, it can inadvertently reveal confidential paths.

In this case, `robots.txt` mentions a `.hidden` folder. This folder contained over 3,000 files and subdirectories. 
One of these files contained the flag.

## Steps to Reproduce

1. Download the entire hidden folder while ignoring `robots.txt` rules:
```
wget -e robots=off -r --no-parent http://192.168.56.101/.hidden/
```

2. Search for all `README` files and extract their content:
```
find . -name 'README' -print -exec cat {} >> readme.txt ; -exec echo ;
```

3. Search for the word “flag” in the file.
```
Hey, here is your flag: d5eec3ec36cf80dce44a896f961c1831a05526ec215693c8f2c39543497d4466
```

## Risks

• **Exposure of sensitive information:** An attacker can discover hidden folders and extract confidential data.
• **Risk of malicious indexing:** Even if `robots.txt` prevents indexing, attackers often analyze it to identify hidden files.

## Recommended Fix

1. **Do not expose sensitive information in robots.txt:** Avoid listing confidential paths.

2. **Restrict access via server configuration:**

• On Apache, add a rule in `.htaccess` to deny access to the folder:
```
<Directory "/var/www/html/.hidden">
    Order Allow,Deny
    Deny from all
</Directory>
```

• On Nginx, block access in `nginx.conf`:
```
location /.hidden {
    deny all;
    return 403;
}
```

3. **Authentication mechanism**: Protect sensitive folders with authentication (.htpasswd, JWT, sessions).
