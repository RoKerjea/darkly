# Cookie manipulation

## Description
the website gives us the cookie
I_am_admin=68934a3e9455fa72420237eb05902327
by default.\
If we try to decrypt it, we get the string "false" encrypted in md5. If we encrypt the string "true" in the same manner, we get b326b5062b2f0e69046810717534cb09\
If we edit the cookie before accessing the site, we get the flag:\
df2eb4ba34ed059a1e3e89ff4dfc13445f104a1a52295214def1c4fb1693a5c3

## Step to reproduce
On any page of the site,\
Right click->Inspect->Storage->Cookies\
Change the value of the cookie i_am_admin to b326b5062b2f0e69046810717534cb09\
And reload the page.

## Danger
If the admin rights are accessible with just the correct cookie value, any user can have admin privilege on the website, and potentially access to all admin commands (ban, unban, edit contents or parameters)

## Recommanded fix
If the admin session rights must be stored in the cookies(no idea if that's standard), then it should be better encrypted. And that encryption key should probably rotate regularly too.
