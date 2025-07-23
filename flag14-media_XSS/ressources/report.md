# Report - media link XSS
## Description
In the index page, one of the image is a link to src
which can be manually edited in the address bar
to a script that is executed when we execute a GET request on it.

the page : https://owasp.org/www-community/attacks/xss/
gives us examples of XSS attacks from html links.

One of the example is how to encode a string, <script>alert('XSS')</script>
into base64 to bypass some insecure filters
it get us the string "PHNjcmlwdD5hbGVydCgndGVzdDMnKTwvc2NyaXB0Pg"
we can use it in the adress bar as:
data:text/html;base64,PHNjcmlwdD5hbGVydCgndGVzdDMnKTwvc2NyaXB0Pg">

The flag is : 928d819fc19405ae09921a2b71227bd9aba106f9d2d37ac412e9e5a750f1506d

## Steps to Reproduce
click on the blue-grey "national security agency" picture
edit
/index.php?page=media&src=nsa
to
/index.php?page=media&src=data:text/html;base64,PHNjcmlwdD5hbGVydCgndGVzdDMnKTwvc2NyaXB0Pg">

## Danger
Any user can unknowingly execute javascript commands client-side, with the same authority as the browser process.
-edit data of the user (html files, pictures, links)
-send files to a third party (sessions cookies, personnal information)
-execute website specific actions (subscription, transfer of assets, deleting something)

## Recommended Fix
Better sanitization of html request, using trustworthy systems (OWASP recommand DOMPurify for example)
