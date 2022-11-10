#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate table games, teams")
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
      WINNER_ID=$($PSQL "SELECT team_id from teams where name = '$WINNER'")
      if [[ -z $WINNER_ID ]]
      then
        INSERT_WINNER_RESULT=$($PSQL "INSERT INTO TEAMS(NAME) VALUES('$WINNER')")
        if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
        then
          echo "$WINNER inserted into teams table"        
          # get inserted id 
          WINNER_ID=$($PSQL "SELECT team_id from teams where name = '$WINNER'")
        fi
      fi

      OPPONENT_ID=$($PSQL "SELECT team_id from teams where name = '$OPPONENT'")
      if [[ -z $OPPONENT_ID ]]
      then
        INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO TEAMS(NAME) VALUES('$OPPONENT')")
        if [[ $INSERT_OPPONENT_RESULT == 'INSERT 0 1' ]]
        then
          echo "$OPPONENT inserted into teams table"

          # get inserted id 
          OPPONENT_ID=$($PSQL "SELECT team_id from teams where name = '$OPPONENT'")
        fi
      fi

      INSERT_GAME_RESULT=$($PSQL "INSERT INTO GAMES(YEAR, ROUND, WINNER_ID, OPPONENT_ID, WINNER_GOALS, OPPONENT_GOALS) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo "game of $YEAR between $WINNER and $OPPONENT inserted"
      fi
  fi
done