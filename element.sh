#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]

then
  if [[ ! $1 =~ [0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.symbol='$1' or elements.name='$1'")
  else
    ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.atomic_number=$1")
  fi

    if [[ -z $ELEMENT ]] 
    then
      echo "I could not find that element in the database."
      echo -e "\nPlease provide an element as an argument."
    else
     echo $ELEMENT | while IFS=\| read ATM_N ATM_M MPC BPC SYMBOL NAME TYPE
     do
      echo "The element with automic number $ATM_N is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATM_M amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
     done
    fi

fi
