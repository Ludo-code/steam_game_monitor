# Steam Game Monitor

Ce script permet de surveiller l'activité de jeu d'un utilisateur Steam. Il envoie des notifications par email ou Discord lorsqu'un utilisateur commence ou arrête de jouer à un jeu, et enregistre le temps de jeu total. Si aucun moyen de notification n'est défini, les notifications seront enregistrées dans un fichier log.

## Fonctionnalités

- Suivi du début et de la fin des sessions de jeu d'un utilisateur Steam
- Notifications par email ou Discord
- Enregistrement des notifications dans un fichier log si aucun moyen de notification n'est défini
- Affichage du nom du jeu et de l'utilisateur Steam
- Formatage de la date et de l'heure en français
- Affichage du temps de jeu total (en heures ou minutes)

## Prérequis

- `curl`
- `jq`
- `sendmail` (pour les notifications par email)

## Installation

1. Clonez ce dépôt :
```sh
git clone https://github.com/votre_nom/steam_game_monitor.git
```

2. Accédez au répertoire du projet :
```sh
cd steam_game_monitor
```

3. Ouvrez le fichier `steam_game_monitor.sh` et remplacez les variables suivantes par vos propres informations :
- `STEAM_API_KEY` : votre clé API Steam par [Faire ça clé d'api Steam ici](https://steamcommunity.com/dev/apikey)
- `STEAM_USER_ID` : l'ID utilisateur Steam à surveiller
- `DISCORD_WEBHOOK_URL` (facultatif) : l'URL du webhook Discord pour les notifications
- `EMAIL` (facultatif) : votre adresse email pour les notifications

## Utilisation

Exécutez le script :
```sh
./steam_game_monitor.sh
```

Le script vérifiera l'activité de jeu de l'utilisateur Steam toutes les 60 secondes et enverra des notifications par email ou Discord, ou enregistrera les notifications dans un fichier log si aucun moyen de notification n'est défini.

## Crédits

L'idée originale de ce projet vient de [misiektoja/steam_monitor](https://github.com/misiektoja/steam_monitor).
