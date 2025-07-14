# Union-based SQL injection

## Description

An SQL injection vulnerability leading to access some hidden data, containing among it the flag

## Steps to Reproduce

On the Members page, it is possible to search a member by member ID. \
When we enter 5, it says "try hack me".
We can see that if we try to add some sql syntax after the input, we receive an SQL error.
```
You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near '' at line 1
```
So the website sends directly the input to SQL, and maybe we can use that.

We used the union-based SQL query to access some more informations about the members table.
> In SQL language, the UNION operator is used to merge the result of 2 queries, this adds the desired data to the data present in the first SQL query.


```sql
5 UNION SELECT table_name, column_name FROM information_schema.columns
```

To see all columns from users.

We observe some columns that are not displayed, e.g. `Commentaire` and `countersign`.

```sql
5 UNION SELECT commentaire, countersign FROM users
```

it gives us, amongst the others user_id (1, 2, 3 and 4), for the 5th:
```
ID: 5 UNION SELECT commentaire, countersign FROM users 
First name: Decrypt this password -> then lower all the char. Sh256 on it and it's good !
Surname : 5ff9d0165b4f92b14994e5c685cdce28
```

--> after doing these steps, we had the flag `3b4e8a30ecbfde518f50f2bda1912b40338ecd71821faeb1e9cdf44cefff95f5`

## Danger

**Data Exposure:** The vulnerability allows an attacker to access sensitive data that should not be available to unauthorized users. Here it is comments and countersign.

## Recommended fixe

1. **Input Sanitization:**

- **Identify User Inputs**: Review all entry points in your applications where users can submit data, such as forms and search bars. This also includes `GET` and `POST` requests, cookies, and any other user-submitted inputs.
- **Implement Input Validation**: Ensure that user inputs adhere to strict, defined rules for data types, lengths, and allowed characters. For example, if expecting a number, check if the input is indeed numeric. Use validation functions like `filter_var()` in PHP or regex patterns in JavaScript.
- **Sanitize Input**: Once validated, sanitize the input by removing or encoding potentially malicious characters. For PHP, you can try functions like `htmlspecialchars()` or `htmlentities()`. For JavaScript, you use `encodeURIComponent()`.
- **Use Prepared Statements for Database Queries**: Avoid directly inserting user inputs into SQL queries. Instead, use prepared statements with bound parameters to prevent SQL injection attacks. This way, inputs are treated as data, not executable code.

Source: [esecurityplanet.com](https://www.esecurityplanet.com/endpoint/prevent-web-attacks-using-input-sanitization/#:~:text=Input%20sanitization%20is%20the%20process,link%20for%20any%20organization's%20cybersecurity.)

2. **Error Handling:** don't expose detailed error messages to users. SQL errors provide attackers with clues about the database structure. The best is to use generic error messages.

5. **Database Permissions:** The database user should have the least privileges necessary. For example, the user should not have the `SELECT` permissions on system tables like `information_schema`.

6. **Regular Security Audits:** Regularly audit the application for vulnerabilities, particularly SQL injection, by performing penetration testing and code reviews.

