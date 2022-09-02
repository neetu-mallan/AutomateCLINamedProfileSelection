#!/bin/bash
MY_PROFILE=$1
echo $MY_PROFILE
#check if given profile exists in aws/credentials, 
#if not show appropriate error
if ! aws configure list-profiles | grep --color=never -Fxq -- "$1"; then
echo "$1 is not a valid profile"
return 2
else
    echo "In else"
    ACCESS_KEY_ID=$(awk '/'"$MY_PROFILE"'/{x=NR+1;next}(NR<=x)' .aws/credentials)
    echo "Access ID: $ACCESS_KEY_ID"
    ACCESS_SECRET_KEY=$(awk '/'"$MY_PROFILE"'/{x=NR+2;next}(NR==x)' .aws/credentials)
    echo "Access SecretKey: $ACCESS_SECRET_KEY"
    IFS='=' read -r var1 var2 <<< "$ACCESS_KEY_ID" #use the = as separator as the key & value are separated with =
    ACCESS_KEY=$(sed 's/^[ \t]*//;s/[ \t]*$//' <<< "$var2") #remove leading & trailing spaces from the variable
    echo "Variable 2=$ACCESS_KEY"
    IFS='=' read -r var3 var4 <<< "$ACCESS_SECRET_KEY"
    ACCESS_SECRET=$(sed 's/^[ \t]*//;s/[ \t]*$//' <<< "$var4")
    echo "Variale 4=$ACCESS_SECRET"
    export AWS_PROFILE=$MY_PROFILE
    export AWS_ACCESS_KEY_ID=$ACCESS_KEY
    echo "$AWS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY=$ACCESS_SECRET
    echo "$AWS_SECRET_ACCESS_KEY"
fi
