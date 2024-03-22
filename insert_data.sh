#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# clean up databases

echo $($PSQL "TRUNCATE TABLE games, teams")

#read games.csv

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #INSERTING TEAMS

    #WINNER TEAM
    #exclude column names
    if [[ $WINNER != 'winner' ]]
    then
      #get team name
      WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
      #if not found
      if [[ -z $WINNER_NAME ]]
      then
      #insert team
        INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      fi
    fi

    #OPPONENT TEAM
    #exclude column names
    if [[ $OPPONENT != 'opponent' ]]
    then
    #get team name
      OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    #if not found
      if [[ -z $OPPONENT_NAME ]]
      then
    #insert new team
      INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      fi
    fi

    #MATCHES
    #exclude column name
    if [[ $YEAR != 'year' ]]
    then
    #get winner id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #get opponent id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #insert match
      INSERT_MATCH=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    #print a message to know match was added
      if [[ $INSERT_MATCH == "INSERT 0 1" ]]
      then
        echo New match added!: $YEAR, $ROUND, $WINNER vs. $OPPONENT. score: $WINNER_GOALS — $OPPONENT_GOALS
      fi
    fi

      

done