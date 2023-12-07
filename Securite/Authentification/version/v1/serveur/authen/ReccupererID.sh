#!/bin/bash

fichier="/srv/empreinte/registre/registre.txt"

# Récupérer la première ligne
premiere_ligne=$(head -n 1 $fichier)
echo "Première ligne : $premiere_ligne"

# Supprimer la première ligne
tail -n +2 $fichier > fichier_sans_premiere_ligne.txt
echo "Fichier sans la première ligne créé : fichier_sans_premiere_ligne.txt"
