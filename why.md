# Why ?

Un petit document qui expliquent certains choix de développement faits.

## {devtag}

On utilise le package {devtag} pour documenter les fonctions non exportées.
Fonctionement :

- Les fonctions exportées portent le tag `@export`
- Les fonctions internes portent le tag `@keywords internal`
- Auparavant, les fonctions non exportées portaient le tag `@noRd` maintenant, on utilise le tag `@dev`

Ce que ça va faire :

- Ajouter une remarque au fichier DESCRIPTION sur l'utilisation de {devtag}
- Ajouter une ligne au .Rbuildignore par fonction non exportée pour ne pas ajouter la doc lors du build

Quelques précautions à prendre (pour les fonctions non exportées) :
- Ne pas utiliser le tag `@name` pour renommer la page de documentation
- Ne pas utiliser le tag `@rdname` pour documenter plusieurs fonctions dans une même page
- Ne pas créer de page de documentation sans fonctions (donc ni avec `NULL` ou `"une chaine de caractères"` comme référence)
