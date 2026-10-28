# Questions métier — Industrial Energy KPI Database
 
Utilisateur : le responsable énergie de l'aciérie.
Chaque question précise une grandeur, une agrégation, un filtre, une période et une unité, et la décision qu'elle sert.
La ligne « Calcul » est complétée au moment d'écrire la requête SQL correspondante.
 
## A. Talon et gaspillage
 
### Q1 — Talon de puissance
- **Question :** Quelle est la puissance de talon (kW, médiane des intervalles 0 h–6 h et du dimanche) et quelle part de l'énergie 2018 représente-t-elle (%) ?
- **Calcul :** grandeur = puissance (kWh × 4) · agrégation = médiane · filtre = heure < 6 ou dimanche · période = 2018 · unité = kW et %
- **Décision servie :** mesurer l'enjeu des consommations permanentes
### Q2 — Énergie et CO₂ du talon
- **Question :** Quelle énergie (MWh/an) et quelles émissions (tCO₂/an) sont consommées au niveau du talon la nuit et le dimanche ?
- **Calcul :** à compléter
- **Décision servie :** chiffrer le gisement avant de lancer un audit des consommateurs permanents
### Q3 — Équipements laissés en marche
- **Question :** Combien d'heures par mois, la nuit ou le dimanche, la puissance dépasse-t-elle 2 × le talon ?
- **Calcul :** à compléter
- **Décision servie :** repérer les équipements laissés en marche hors production
## B. Pointe et puissance souscrite
 
### Q4 — Pointe mensuelle
- **Question :** Quelle est la pointe mensuelle (kW), avec sa date et son heure ?
- **Calcul :** grandeur = puissance (kW) · agrégation = max avec horodatage (ROW_NUMBER par mois) · période = chaque mois de 2018 · unité = kW, date et heure locales
- **Décision servie :** ajuster la puissance souscrite
### Q5 — Heures proches de la pointe
- **Question :** Combien d'heures par an la puissance dépasse-t-elle 80 % de la pointe annuelle, et à quelles heures de la journée ?
- **Calcul :** à compléter
- **Décision servie :** évaluer un écrêtement (décalage de charge, batterie)
### Q6 — Facteur de forme
- **Question :** Quel est le facteur de forme mensuel (pointe / puissance moyenne) ?
- **Calcul :** à compléter
- **Décision servie :** identifier les mois où les pointes coûtent cher par rapport au volume
## C. Profil et déplacement de charge
 
### Q7 — Profil horaire
- **Question :** Quel est le profil horaire moyen (kW, 24 valeurs) des jours ouvrés et des dimanches ?
- **Calcul :** grandeur = puissance (kW) · agrégation = moyenne · regroupement = heure locale × dimanche ou non · période = 2018 · unité = kW
- **Décision servie :** comprendre le rythme de production
### Q8 — Énergie par période tarifaire
- **Question :** Quelle énergie (MWh et %) est consommée dans chaque période tarifaire ?
- **Calcul :** grandeur = énergie (kWh) et nombre d'intervalles · agrégation = somme et part (fonction de fenêtre) · regroupement = période tarifaire · unité = MWh, % énergie, % temps
- **Décision servie :** décider si un décalage de charges vers les heures creuses vaut le coup
### Q9 — Énergie par jour de la semaine
- **Question :** Quelle est l'énergie moyenne (MWh) par jour de la semaine ?
- **Calcul :** à compléter
- **Décision servie :** évaluer un lissage entre jours ouvrés et week-end
## D. Énergie réactive
 
### Q10 — Temps au-delà du seuil
- **Question :** Quel % du temps de fonctionnement (P > 0) présente un tan φ > 0,4, par mois ?
- **Calcul :** grandeur = tan φ = Q / P · agrégation = part des intervalles > 0,4 · filtre = P > 0 · regroupement = mois · unité = % du temps de fonctionnement ; complément : tan φ pondéré Σ Q / Σ P
- **Décision servie :** décider si une compensation est nécessaire
### Q11 — Réactif facturable et coût
- **Question :** Combien de kVArh dépassent le seuil (Q − 0,4 P, quand positif) par mois, et quel est le coût annuel avec un prix en paramètre ?
- **Calcul :** à compléter
- **Décision servie :** calculer le retour sur investissement de condensateurs
### Q12 — Facteur de puissance par période
- **Question :** Quel est le facteur de puissance pondéré (calculé à partir des sommes de P et Q) dans chaque période tarifaire ?
- **Calcul :** à compléter
- **Décision servie :** localiser le problème dans le temps : batterie de condensateurs fixe ou automatique ?
### Q13 — Surcompensation
- **Question :** Quel % du temps le site est-il en réactif capacitif (leading > 0) ?
- **Calcul :** à compléter
- **Décision servie :** détecter une surcompensation
## E. Carbone et dérives
 
### Q14 — Émissions mensuelles
- **Question :** Quelles sont les émissions mensuelles (tCO₂) et leur écart à la moyenne annuelle ?
- **Calcul :** à compléter
- **Décision servie :** reporting carbone (le CO₂ étant énergie × facteur, son profil suit celui de l'énergie)
### Q15 — Jours anormaux
- **Question :** Quels jours ouvrés ont une énergie qui s'écarte de plus de 20 % de la moyenne du même jour de la semaine, dans le même mois ?
- **Calcul :** à compléter
- **Décision servie :** repérer les dérives à investiguer
 
Claude finished the response
