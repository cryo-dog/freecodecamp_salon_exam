#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]] 
  then
    echo -e "\n$1"
  fi

  echo -e "\nWelcome to My Salon, how can I help you?"

  SERVICES_OFFERED=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES_OFFERED" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU "Please select an item from the list!"
  else
  echo $SERVICE_NAME
  EXISTING_CHECK
  BOOK_APP
  fi

}

EXISTING_CHECK() {
  
  echo -e "\nWhat's your phone number, dear person?"

  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    # Say you are new and run new customer function
    echo -e "\nSeems like you are a new customer. Let's add you to our list"
    CREATE_CUSTOMER
  else
    # Say hi and start ordering the service
    echo -e "\nHi $CUSTOMER_NAME,"
  fi
}

CREATE_CUSTOMER() {
echo -e "\nWhat's your name?"
read CUSTOMER_NAME
INSERT_CUST=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
echo -e "\nPerfect. Hi $CUSTOMER_NAME,"
}

BOOK_APP() {
#empty for now
echo "let's get you sorted. What time would you like your appointment?"
read SERVICE_TIME

INSERT_APP=$($PSQL "INSERT INTO appointments(service_id, time, customer_id) VALUES($SERVICE_ID_SELECTED, '$SERVICE_TIME',$CUSTOMER_ID)")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME. See you then! :)"
}

MAIN_MENU