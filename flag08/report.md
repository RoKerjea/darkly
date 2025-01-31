# Feedback Page Validation Bypass

## Description
The feedback submission form contains a **client-side validation error** due to an undefined variable `mtxMessage`. This allows bypassing validation and triggering an unintended behavior.

When submitting feedback, an error appears in the console:

```
Uncaught ReferenceError: mtxMessage is not defined
    validate_form http://192.168.56.101/index.php?page=feedback:57
    onsubmit http://192.168.56.101/index.php?page=feedback:1
```

By inspecting the HTML source code, we found that `mtxMessage` is referenced in JavaScript but never defined:

```js
if (validate_required(mtxMessage,"Message can not be empty.")==false)
  {mtxMessage.focus();return false;}
```

By submitting an empty message, the script fails, and a **flag is returned**.

## Steps to Reproduce

1. Open the feedback page:  
   ```
   http://192.168.56.101/index.php?page=feedback
   ```
2. Open the browser **console**
3. Click on **Submit** without entering a message
4. Observe the JavaScript error in the console: `mtxMessage is not defined`.
5. Since validation fails, the request goes through, and the system returns a **flag**:

```
0fbb54bbf7d099713ca4be297e1bc7da0173d8b3c21c1811b916a3a86652724e
```

## Danger

- **Client-side validation bypass**: The validation occurs in JavaScript, which can be disabled or modified by an attacker.
- **Potential privilege escalation**: If similar vulnerabilities exist elsewhere, an attacker could manipulate form data to **bypass security restrictions**.
- **Lack of proper error handling**: The system fails in an unintended way, revealing potentially sensitive information.

##  Recommended Fix

1. **Fix the JavaScript error**:
   - Ensure `mtxMessage` is correctly defined before being used.
   ```js
   var mtxMessage = document.getElementById("message");
   ```
2. **Implement server-side validation**:
   - Never rely **only** on JavaScript for validation.
   - Validate the input on the server before processing the request.
   ```php
   if (empty($_POST['message'])) {
       die("Error: Message cannot be empty.");
   }
   ```
3. **Use proper error handling**:
   - Return generic error messages to prevent information leaks.
   - Log errors securely instead of exposing them to the client.

