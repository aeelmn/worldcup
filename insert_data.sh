#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
 echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != "year" ]]
then
# get team id
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ;")

# if not found
if [[ -z $TEAM_ID ]]
then

# insert team
INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")

# get new team id
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ;")



fi

# get 2
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
# if not found
if [[ -z $TEAM_ID ]]
then

# insert team
INSERT_TEAM_RESULT2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
# get new team id
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE  name='$OPPONENT';")

fi
  fi

done

# create games table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != "year" ]]
then
# insert games table data
INSERT_GAMES_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND',(SELECT team_id FROM teams WHERE name='$WINNER'),(SELECT team_id FROM teams  WHERE name ='$OPPONENT'), $WINNER_GOALS, $OPPONENT_GOALS);")


fi
done
