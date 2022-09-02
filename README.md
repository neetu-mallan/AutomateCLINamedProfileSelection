# AutomateCLINamedProfileSelection
This repo consists of an automation script to select named profiles for the AWS CLI and set the access key credentials

How to invoke the bash script:
source <AbsolutePath>/setAWSProfile.sh <profile_name>
This will set the AWS Profile for the entirety of the current Shell session.
  
Inner workings of the script:
First check whether the profile given as an argument is present in the .aws/credentials file, if not then print an error showing "<profile_name> is not valid" as checked using the below condition
if ! aws configure list-profiles | grep --color=never -Fxq -- "$1"; 

The structure of the credentials file is:
  
[profile_name]
aws_access_key_id=AKIAI44QH8DHBEXAMPLE
aws_secret_access_key=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
  
select the location of the <profile_name> in the credentials file, then select the next two lines to get the access key ID & secret access key
$(awk '/'"$MY_PROFILE"'/{x=NR+1;next}(NR<=x)' .aws/credentials)

To just get the access key ID's value, we need to split the line aws_access_key_id=AKIAI44QH8DHBEXAMPLE using the = separator as done below: 
 IFS='=' read -r var1 var2 <<< "$ACCESS_KEY_ID"

Remove leading & trailing spaces from the access key ID's value.
ACCESS_KEY=$(sed 's/^[ \t]*//;s/[ \t]*$//' <<< "$var2")
                                               
Export the values into environment variables:
export AWS_ACCESS_KEY_ID=$ACCESS_KEY                                              
