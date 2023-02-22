#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
SYMBOL_REGEX="^[A-Za-z]{1,2}$"
NAME_REGEX="[a-zA-Z]+"
NUMBER_REGEX="^[1-9]*$"

ELEMENT_INFO_OUTPUT() {
if [[ -z $1 ]]
  then
    echo -e "I could not find that element in the database."
  else
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
}

if [[ ! -z $1 ]]
then
  if [[ "$1" =~ $SYMBOL_REGEX ]]
  #Is the input a symbol?
  then
      echo -e "$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1'")" | while IFS="|" read TYPE_ID ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NAME TYPE
      do
        ELEMENT_INFO_OUTPUT $ATOMIC_NUMBER
      done

  elif [[ $1 =~ $NUMBER_REGEX ]]
    then
    #Is the input a number?
    echo -e "$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = '$1'")" | while IFS="|" read TYPE_ID ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NAME TYPE
      do
        ELEMENT_INFO_OUTPUT $ATOMIC_NUMBER
      done

  elif [[ "$1" =~ $NAME_REGEX ]]
    then
    #Is the input an element name?
    echo -e "$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1'")" | while IFS="|" read TYPE_ID ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NAME TYPE
      do
        ELEMENT_INFO_OUTPUT $ATOMIC_NUMBER
      done
  fi
else
  echo -e "Please provide an element as an argument."
fi