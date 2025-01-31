# Vulnerability: Exposure of the `.htpasswd` File in `robots.txt`

## Description

As seen in Flag 2, the `robots.txt` file indicates which paths should not be indexed, which can provide attackers with clues.

`robots.txt` mentions a `.htpasswd` file.  
`.htpasswd` is a file that contains encrypted credentials used to protect certain sections of a website.  
This file contains an MD5 hash of a password, which can be easily cracked.

Once the password is recovered, an attacker can log into the `/admin` page using the `root` user, gaining access to the flag.

## Steps to Reproduce

1. Look for disallowed files in `robots.txt`:

```plaintext
http://192.168.56.101/robots.txt
```

2. Access the exposed `.htpasswd` file:

```plaintext
http://192.168.56.101/.htpasswd
```

**Result**:
```plaintext
root:437394baff5aa33daa618be47b75cb49
```

3. Crack the MD5 hash of the password:  
• Use an MD5 hash cracking website like [md5hashing.net](https://md5hashing.net/hash)  
• Enter `437394baff5aa33daa618be47b75cb49`  
• Obtained password: `qwerty123@`

4. Log into the admin interface:

• Go to the `/admin` page:

```plaintext
http://192.168.56.101/admin
```

• Enter the credentials:
    - **Username**: root  
    - **Password**: qwerty123@

5. After logging in, the page displays the flag:

```plaintext
d19b4823e0d5600ceed56d5e896ef328d7a2b9e7ac7e80f4fcdb9b10bcb3e7ff
```

## Risks

• **Publicly accessible `.htpasswd` file**: A file containing credentials should never be exposed on a web server.  
• **Weak passwords**: Using MD5 hashing is obsolete and vulnerable to brute-force attacks and precomputed hash databases (rainbow tables).  
• **Unsecured admin access**: An attacker can take full control of the `/admin` interface and compromise the entire site.

## Recommended Fix

### 1. Prevent access to the `.htpasswd` file

• On Apache, add the following rule in `.htaccess`:

```apache
<Files ".htpasswd">
    Order Allow,Deny
    Deny from all
</Files>
```

• On Nginx, block access in `nginx.conf`:

```nginx
location ~ /\.ht {
    deny all;
}
```

### 2. Do not expose `.htpasswd` in `robots.txt`

• **Best solution**: Do not reference `.htpasswd` at all.  
• **Alternative**: If necessary, move the file outside the web-accessible directory.

### 3. Use a secure hashing algorithm

MD5 is outdated for password hashing.

#### a. Too fast

MD5 was designed for speed, making it efficient for checksums but a poor choice for password storage.  
An attacker can test billions of passwords per second using a basic GPU.

| Algorithm | Hashes per second on a modern GPU |
|-----------|----------------------------------|
| **MD5** | ~10 billion/s 🚀 |
| **SHA-256** | ~1 billion/s |
| **bcrypt (cost=12)** | ~200 hashes/s 🐢 |
| **Argon2 (default settings)** | ~100 hashes/s 🐢 |

#### b. No salt in MD5

MD5 only hashes the given password.  
This means that two users with the same password will have the same hash.

**Consequences**:  
• An attacker who gains access to a database hashed with MD5 can immediately identify users with the same password.  
• They can compare hashes against precomputed databases known as Rainbow Tables.

**Solution**:  
- Modern algorithms (bcrypt, Argon2) add a **salt** (random value), ensuring that even identical passwords produce unique hashes.

#### c. Vulnerability to Rainbow Tables

Rainbow Tables are massive databases containing precomputed MD5 hashes for millions of passwords.  
• An attacker can simply look up an MD5 hash instead of computing it.  
• Bcrypt, scrypt, and Argon2 make this attack ineffective by incorporating a **salt** (each hash is unique).

**Decrypting an MD5 hash often doesn’t require brute force—just a simple database lookup.**

#### d. MD5 is vulnerable to GPU and FPGA attacks

Modern processors (GPUs, FPGAs, ASICs) are optimized to break MD5 extremely quickly.  
With a basic GPU, an attacker can test over **10 billion MD5 hashes per second**.  
**bcrypt** and **Argon2** are designed to prevent this by making computations more memory- and time-intensive.

#### e. MD5 is susceptible to collisions

A **collision** means that two different inputs produce the same MD5 hash.  
• An attacker could generate a different password that results in the same hash.  
• **bcrypt, scrypt, and Argon2 are resistant to collisions.**

➡ **Use bcrypt, scrypt, or Argon2.**

### 4. Implement stronger authentication

• Enforce strong passwords (e.g., at least 12 characters with uppercase, numbers, and special characters).  
• Enable **two-factor authentication (2FA)** for `/admin`.  
• Restrict access to `/admin` by **IP address**, if possible.

