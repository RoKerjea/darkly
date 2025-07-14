# Exposure of a Hidden Folder Referenced in robots.txt

## Description

The `robots.txt` file tells to the search engines the parts of the site that should not be indexed. 
-> It can reveal which parts the developers want to hide from the public.

We found that `robots.txt` contains a `.hidden` folder. This folder contained ~ 3,000 files within directories and subdirectories. 
One of these files contained the flag.

## Steps to Reproduce

1. Download the hidden folder, ignoring `robots.txt` rules:
```
wget -e robots=off -r --no-parent http://192.168.56.101/.hidden/
```

2. Search all `README` files and extract their content:
```
find . -name 'README' -print -exec cat {} >> readme.txt ; -exec echo ;
```

3. Search the word “flag” in the file.
```
Hey, here is your flag: d5eec3ec36cf80dce44a896f961c1831a05526ec215693c8f2c39543497d4466
```

## Risks

• **Exposition of sensitive information:** An attacker can discover hidden folders and extract confidential data.
• **Risk of malicious indexing:** Even if `robots.txt` prevent indexing, attackers can analyze it to know which files you want to be prevented from indexing.

## Recommended Fix

1. **Do not expose sensitive information in robots.txt**

2. **Restrict access using the server configuration:**

• `nginx.conf`:
```
location /.hidden {
    deny all;
    return 403;
}
```
