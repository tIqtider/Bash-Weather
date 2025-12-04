#!/usr/bin/bash

#hardcode city
city="Cookeville, TN"

#create URL variable
URL="https://api.open-meteo.com/v1/forecast?latitude=36.162838&longitude=-85.501640&hourly=precipitation_probability&current=temperature_2m&timezone=America%2FChicago&forecast_days=3&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch"

#save JSON data from API
response=$(curl -s $URL)

#grab current hour
current_time=$(date +"%H")
format_hour=$(date +"%I:%M %p")

#print current_temp
temperature=$(echo $response | jq .current.temperature_2m)
#remove digits after decimal 
temperature=${temperature%.*}

#print avg precipitation% for 3 hrs
precipitation1=$(echo $response | jq .hourly.precipitation_probability[$current_time])
precipitation2=$(echo $response | jq .hourly.precipitation_probability[$current_time+1])
precipitation3=$(echo $response | jq .hourly.precipitation_probability[$current_time+2])
total_precipitation=$(($precipitation1 + $precipitation2 + $precipitation3))
avg_precipitation=$(((total_precipitation)/3))
#remove digits after decimals
avg_precipitation=${avg_precipitation%.*}

#print loading screen (ref: Youtube)
echo
echo "Fetching weather updates..."
sleep 1
echo "------"
sleep 1
echo "**----"
sleep 1
echo "****--"
sleep 1 
echo "******"
sleep 1
echo 
echo

#print output
echo "${format_hour}"
echo "It is currently ${temperature}°F in ${city}, with a ${avg_precipitation}% chance to rain in the next three hours." 

#provide recommendation based on the weather
if [[ $temperature -ge 70 ]]; then
	if [[ $avg_precipitation -lt 50 ]]; then
		echo "My Recommendation: Wear something light"
	else
		echo "My Recommendation: Wear something light & bring an umbrella or rain jacket"
	fi

elif [[ $temperature -ge 50 && $temperature -lt 70 ]]; then
	if [[ $avg_precipitation -lt 50 ]]; then
		echo "My Recommendation: Wear layers"
	else
		echo "My Recommendation: Wear layers & carry an umbrella"
	fi 

else 
	if [[ $avg_precipitation -lt 50 ]]; then
		echo "My Recommendation: Wear a coat"
	else
		echo "My Recommendation: Wear a coat & carry an umbrella"
	fi
fi
