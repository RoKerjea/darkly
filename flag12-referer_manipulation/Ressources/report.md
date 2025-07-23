# Report - manipulating the referer and user-agent
## Description
In the page "about us", if we inspect the code, we can see a bloc of comment containing a bit of lorem ipsum and the lines:

You must come from : "https://www.nsa.gov/".
and
Let's use this browser : "ft_bornToSec". It will help you a lot.

## Steps to Reproduce

Right click->Inspect->Storage->Cookies\
Change the value of the cookie i_am_admin to b326b5062b2f0e69046810717534cb09\
then Inspect->network
right clic on the GET ?page=XXXXXX request-> edit and resend
we can edit the user-agent to be "ft_bornToSec"
(if i understood the parameters of mozilla correctly, we could also edit the referer here, but instead i just used an addon)
if we use an addon to change the referer to https://www.nsa.gov/
Command : 
```bash
 curl 'http://192.168.56.106/?page=b7e44c7a40c5f80139f0a50f3650fb2bd8d00b0d24667c4c2ca32c88e13b758f' -H 'User-Agent: ft_bornToSec'  -H 'Referer: https://www.nsa.gov/' |grep flag
```
and send the edited request, we receive:

"The flag is : f2a29020ef3132e01dd61df97fd33ec8d7fcd1388cc9601e7db691d17d4d6188"

## Danger
We don't have a visible example here, but if the site behave very differently depending on the cient informations, a user could edit those informations quite easily.
It might be possible for a destop user to access the site as another platform. If the website use different security system depending on the plateform, itcould be a vulnerability.

## Recommended Fix
A website have very little reason to behave diferently depending on the header referer and the user agent. It might present differently to it's user, depending on the platform, but it's relying on an editable string to do that, That's not very secure.

Using any other system than the header to have trustworthy informations about the current user.
