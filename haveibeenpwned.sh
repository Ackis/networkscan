#!/bin/bash
#edited on 4/19/2018 9:02PM EST
echo  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo  %%%   RESPONSE CODES:                         
echo  %%% 200- Email was apart of a compromise. 
echo  %%% 400- Bad request                      
echo  %%% 403- Forbidden                        
echo  %%% 404- No account, no compromise ":)"    
echo  %%% 429- Too many request. Slow it down    
echo  %%%                                       
echo  %%%  WILL START IN 5 SECONDS               

#sleep 5

for pwned in $(cat emails.txt)
  do
   echo "Processing $pwned..."
   echo ####

owned="200"

pwned_verdict=$(curl -s -o /dev/null -w "%{http_code}" 'https://haveibeenpwned.com/api/v2/breachedaccount/'$pwned'?truncateResponse=true')

sleep 2

pwned_reason=$(curl -s -A 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36 OPR/38.0.2220.41' -w "Response-Code: %{http_code}" 'https://haveibeenpwned.com/api/v2/breachedaccount/'$pwned'?truncateResponse=true')

echo $pwned_reason
 if [ $pwned_verdict == $owned ]
  then
echo $pwned "has been compromised from these various websites."
  else
echo $pwned "has not been compromised used by its websites"
fi

   echo ####
   echo ####
   sleep 2

done
