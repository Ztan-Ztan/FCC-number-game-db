#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME

USERNAME_RETURN=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
USER_ID_RETURN=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USERNAME_RETURN ]]
  
  then
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here.\n"
    INSERT_USERNAME_RETURN=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
    USER_ID_RETURN=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
    
  else 
    GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID_RETURN")    
    BEST_GAME=$($PSQL "SELECT MIN(num_of_guesses) FROM games WHERE user_id=$USER_ID_RETURN")
    echo Welcome back, $USERNAME\! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.

fi

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

GUESS_COUNT=0

echo "Guess the secret number between 1 and 1000:"

while true
do
  read USER_GUESS

  if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
    
    then
      echo -e "That is not an integer, guess again:"
      continue
      
    fi
      ((GUESS_COUNT++))

      if [[ $USER_GUESS -eq $SECRET_NUMBER ]]
      then
        break
      elif [[ $USER_GUESS -lt $SECRET_NUMBER ]]
        
        then
          echo "It's higher than that, guess again:"
        
        else 
          echo "It's lower than that, guess again:"
  fi
done

INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, secret_number, num_of_guesses) VALUES ($USER_ID_RETURN, $SECRET_NUMBER, $GUESS_COUNT)")
echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
