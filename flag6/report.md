# SQL Injection in Image Search

## Description

Image search asked to input an ID. \
By searching IDs manually (`1, 2, 3, 4, 5`), we discovered an image titled **"HackMe?"**. \
This hinted that the search mechanism might be exploitable. \

Furthermore, search functionality for images by ID is vulnerable to **SQL Injection**.

By leveraging **SQL Injection**, we identified a table named `list_images`, containing the columns:
- `id`
- `url`
- `title`
- `comment`

Since `comment` is not displayed, we attempted to extract its data manually.

## Steps to Reproduce

### Identify Table Structure

By injecting the following SQL payload, we listed existing table columns:

```sql
5 AND 1=2 UNION SELECT table_name, column_name FROM information_schema.columns
```

**Findings:** We discovered the table `list_images` with the columns: `id`, `url`, `title`, and `comment`.

### Extract Hidden `comment` Column

Since `comment` was not displayed by default, we crafted a query to retrieve its content:

```sql
5 UNION ALL SELECT id, comment FROM list_images
```

**Findings:** The comment of id 5 contained a cryptographic challenge:
```
If you read this just use this md5 decode lowercase then sha256 to win this flag ! : `1928e8083cf461a51303633093573c46`
```

### Solve the Cryptographic Challenge

- **MD5 Decode** `1928e8083cf461a51303633093573c46` → `albatroz`
- **SHA-256 Hash** of `albatroz` (flag):
```
fe0ca5dd7978ae1baae2c1c19d49fbfbb37fe7905b9ad386cbbb8206c8422de6
```

## Danger
- **SQL Injection**: The search input is directly injected into the SQL query, allowing unauthorized access to the database structure and data.
- **Data Exposure**: Sensitive columns such as `comment` can be retrieved even if they are not meant to be displayed.
- **Potential for Full Database Dump**: An attacker could enumerate all tables, extract user credentials, or even modify the database.

## Recommended Fix

1. **Use Prepared Statements** (Parameterized Queries) to prevent direct SQL injection.

   ```php
   $stmt = $pdo->prepare("SELECT id, url, title FROM list_images WHERE id = ?");
   $stmt->execute([$user_input]);
   ```
2. **Sanitize and Validate User Input**

Ensure that only **numeric values** are accepted when querying by ID.
   ```php
   if (!ctype_digit($_GET['id'])) { exit("Invalid input"); }
   ```
3. **Limit Database Permissions**

Ensure the web application uses a **read-only** database user whenever possible.

4. **Hide Internal Database Structure**

Never expose database schema information through error messages or direct queries.

5. **Implement Web Application Firewalls (WAFs)**

Use **ModSecurity** or similar tools to detect and block SQL Injection attempts.
