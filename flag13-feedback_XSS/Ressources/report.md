# Report - feedback form xss
## Description
on the page /index.php?page=feedback, if we inspect->console, we can see 2 error messages
"checkForm is not defined" and
"mtxMessage is not defined"
the form button doesnt use the appropriate function.

if we send a feedback with a username containing a sinle letter contained in the words "script,"alert" and or a single closing or opening < >.
It send us the flag:
0fbb54bbf7d099713ca4be297e1bc7da0173d8b3c21c1811b916a3a86652724e

I don't understand exactly how it happen but i suspect that javascript check the input and compare it with a nonexistent fonction containing the expression "<script>alert"
if we wrote the entire words :
'alert',
'script',
'<script' and
'script>'
we also get the flag.

## Steps to Reproduce
on the page /index.php?page=feedback
write a single letter contained in the expression "scriptalert"
and click "sign guestbook"

## Danger
The page use a non existent function to check the feedback input. That already allow a user to bypass the intended protection.
the way in which it break also make me suspect that we could write a javascript function in a field to execute our code with the authority of the serveur.
The way the VM is setup doesn't alow us to really experiment with that unfortunatly.

## Recommended Fix

use the proper "validate_form" method instead of "check_form"
And, just reading the console for error messages in general,
it's always useful.