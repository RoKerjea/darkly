# Report - Path Traversal Vulnerability

## Description

The website is vulnerable to **Path Traversal**, allowing an attacker to access files outside the intended directory by modifying the `page` parameter used for navigation.

By manipulating the `page` parameter in the URL, we can traverse directories and access sensitive system files.

## Steps to Reproduce

1. Open a web browser and visit:
   ```
   http://192.168.56.101/index.php?page=../../../../../../../etc/passwd
   ```
2. The server responds by displaying the contents of `/etc/passwd`, confirming the vulnerability.
3. The response includes the following message, revealing the flag:

   ```
   Congratulaton!! The flag is :
   b12c4b2cb8094750ae121a676269aa9e2872d07c06e429d25a63196ec1c8c1d0
   ```

## Danger

- **Sensitive File Exposure**: Attackers can retrieve system files, including `/etc/passwd`, which may contain information about user accounts.
- **Potential Remote Code Execution (RCE)**: If writable files like `.php` can be accessed and modified, attackers could execute arbitrary code.
- **Compromise of Application Security**: Path traversal allows enumeration of directories and access to configuration files, potentially revealing credentials.

## Recommended Fix

1. **Sanitize and Validate User Input**:
   - Restrict the `page` parameter to only accept **expected values**.
   ```php
   $allowed_pages = ['home', 'about', 'contact'];
   if (!in_array($_GET['page'], $allowed_pages)) {
       die("Invalid page request");
   }
   ```

2. **Use Absolute Paths**:
   - Avoid directly including files based on user input.
   - Define a fixed directory for pages and append sanitized filenames.
   ```php
   $page = basename($_GET['page']);
   include("pages/$page.php");
   ```

3. **Implement Web Server Restrictions**:
   - Use `.htaccess` (Apache) or `nginx.conf` to **deny access** to sensitive directories.
   ```apache
   <Directory /var/www/html>
       Options -Indexes
   </Directory>
   ```

4. **Use a Web Application Firewall (WAF)**:
   - Deploy a **WAF** to detect and block path traversal attempts.



