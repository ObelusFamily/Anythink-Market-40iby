#!/bin/sh

for i in {100..200}
do
    #Create user:
    echo $i
    echo "Creating username"
    curl -X POST http://localhost:3000/api/users -H 'Content-Type: application/json' -d '{"user":{"username":"username'${i}'","email":"username'${i}'@user.com","password":"userpass"}}'

    #Login user:
    echo "Logging in"
    loginres=$(curl -X POST http://localhost:3000/api/users/login -H 'Content-Type: application/json' -d '{"user":{"email":"username'${i}'@user.com","password":"userpass"}}')

    #Get token -
    token=$(echo $loginres | python3 -c "import sys, json; print(json.load(sys.stdin)['user']['token'])")
    echo "Token - " $token
    #Create item

    echo "Create item"
    itemres=$(curl -X POST http://localhost:3000/api/items/ -H 'Content-Type: application/json' -H "Authorization: Bearer $token" -d '{"item":{"title":"item_'$i'","description":"description_'$i'","image":"https://res.cloudinary.com/wilco/image/upload/v1640709888/anythink-assets/bots/ness-headshot_puusqr.png","tagList":["tag1","tag2","tag3"]}}')

    echo "Get item slug name"
    #Get item -
    item=$(echo $itemres | python3 -c "import sys, json; print(json.load(sys.stdin)['item']['slug'])")
    echo $item
    #Add comment
    echo "Add comment"
    curl -X POST http://localhost:3000/api/items/$item/comments -H 'Content-Type: application/json' -H "Authorization: Bearer $token" -d '{"comment":{"body":"111comment body"}}'
done


yarn seeds
