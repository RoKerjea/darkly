# Vulnerability: Exposure of the `.htpasswd` File in `robots.txt`

## Description

As seen in Flag 2, the `robots.txt` file indicates which paths should not be indexed, which can give attackers some clues on sensitive locations.

`robots.txt` mentions a `.htpasswd` file.  
`.htpasswd` is a file that contains encrypted credentials used to protect certain sections of a website.  
This file contains a MD5 hash of a password. MD5 is easily cracked.

Once the password is recovered, it is possible to log into the `/admin` page using the `root` user, and so access the flag.

## Steps to Reproduce

1. Look for files in `robots.txt`:

```
http://192.168.56.101/robots.txt
```

2. Access the `.htpasswd` file:

```
http://192.168.56.101/.htpasswd
```

**Result**:
```
root:437394baff5aa33daa618be47b75cb49
```

3. Crack the MD5 hash of the password:  
• We used [md5hashing.net](https://md5hashing.net/hash)  
• Enter the hashed password `437394baff5aa33daa618be47b75cb49`  
• Obtained password: `qwerty123@`

4. Log into the admin interface:

• Go to the `/admin` page:

```
http://192.168.56.101/admin
```

• Enter the credentials:
    - **Username**: root  
    - **Password**: qwerty123@

5. After logging, the page displays the flag:

```
d19b4823e0d5600ceed56d5e896ef328d7a2b9e7ac7e80f4fcdb9b10bcb3e7ff
```

## Risks

• **Publicly accessible `.htpasswd` file**: A file which contains credentials should never be exposed on a web server.
• **Weak hashing**: Using MD5 hashing is obsolete and vulnerable to brute-force attacks and precomputed hash databases (rainbow tables).  
• **Unsecured admin access**: An attacker can take full control of the `/admin` interface and compromise the entire site.

## Recommended Fix

### 1. Protect the `.htpasswd` file

Do not expose `.htpasswd` in `robots.txt`

Deny its access from the server configuration, `nginx.conf`:

```nginx
location ~ /\.ht {
    deny all;
}
```

### 2. Use a secure hashing algorithm

MD5 is outdated for password hashing.

#### a. Md5 is vulnerable to brute-force

MD5 has been designed for speed, so it is efficient for checksums but it is a bad choice for password storage.  
An attacker can test billions of pwd per second using a basic GPU.

**Solution**: **bcrypt** and **Argon2** are designed to prevent this by being far more slow to compute.

#### b. No salt in MD5

MD5 only hashes the given password.
This means that two users with the same password will have the *same hash*.

==> Attackers can compare hashes with precomputed databases ("Rainbow Tables", massive db with precomputed MD5 hashes of millions of common pwds).

**Solution**: Modern algorithms (bcrypt, Argon2) add a salt (random value), so that each password have a unique hash.

### 3. Implement stronger authentication

• Use stronger password
• Enable 2FA for `/admin`
• Restrict access to `/admin`
