# Report - insecure file upload

## Description

The site is not correctly protected against malicious file upload. We can bypass the filter to upload executable files in .xhtml format. We only need to edit the upload POST request to change the Content-Type.


## Steps to Reproduce

1. on the page http://192.168.56.101/index.php?page=upload
2. click "choose an image to upload" -> select any .xthml file
3. if we click the button "UPLOAD", the site tell us "Your image was not uploaded."
4. But if we inspect the page->network->right click on the POST request-> "edit and resend", we can see the header and body of the post request that failed.
5. Simply replacing the line "Content-Type: application/xhtml+xml" by "Content-Type: image/jpeg"
and clicking "Send" gives us the flag "46910d9ce35b385885a9f7e2b336249d622f29b267a1771fbacf52133beddba8".(we need to see the response to that request in the inspector window, not in the main browser)
6. Ou avec un curl : 
``` bash
curl -X POST \
  -F "uploaded=@./test.php;type=image/jpeg" -F "Upload=Upload" \
  "192.168.56.106/index.php?page=upload"
```
## Danger

- The website might accept files in format that could cause problems just by being present
- it might allow an attacker to upload an executable file that could take any action imaginable if he find a way to get execution permission.


## Recommended Fix

- Stricter check on uploaded files (check if name contain ".xhtml" for example, or more generaly if it doesn't end in the allowed format)
- check the content-type field in the header AND the body of a request.
