# Report - Open redirect

## Description
By modifying the adress of an external link from the website, for example "href="index.php?page=redirect&site=instagram", and changing the website target, we can create a valid url from a "trusted" source that would direct user to a potentially malicious website.

## Steps to Reproduce
just put the following adress in a browser:
"http://192.168.56.101/index.php?page=redirect&site=fakewebsite.com"


## Danger
we can create an imitation of the website with a valid url that would convince a user he is on the proper website and can use his password or make payment.

## Recommended Fix

