#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games;")

    cat games.csv | while IFS="," read ANO PARTIDA VENCEDOR OPONENTE GOLS_VENCEDOR GOLS_OPONENTE
do
  if [[ $VENCEDOR != "winner" ]]
  then
    # insert names of winners and opponents
    INSERT_WINNERS=$($PSQL "INSERT INTO teams(name) VALUES('$VENCEDOR')")
    INSERT_OPPONENTS=$($PSQL "INSERT INTO teams(name) VALUES('$OPONENTE')")
    if [[ $INSERT_WINNERS == "INSERT 0 1" && $INSERT_OPPONENTS ]]
    then
      echo "Inserted into teams, $VENCEDOR $OPONENTE"
    fi

    #Get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$VENCEDOR';")
    #Get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPONENTE';")

    #insert games data
    INSERT_GAME_DATA=$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($ANO,'$PARTIDA',$WINNER_ID,$OPPONENT_ID,$GOLS_VENCEDOR,$GOLS_OPONENTE);")
    if [[ $INSERT_GAME_DATA == "INSERT 0 1" ]]
    then
      echo "Inserted into games: $ANO,$PARTIDA,$WINNER_ID,$OPPONENT_ID,$GOLS_VENCEDOR,$GOLS_OPONENTE"
    fi


    
  fi
done
