- réactance / inductance / Réluctance
- Lampes à décharge (ionisation d'un gaz métallique) / Ballast (VAR)
- Variateurs régulent le cos phi à faible régime en diminuant le champ magnétisnant.
- Matériau réfractaire : forte résistance à un facteur susceptible à le dégrager
- 
                 Mauvais FP
                     │
          ┌──────────┼──────────┐
          ↓          ↓          ↓
       Q ↑         S ↑          I ↑
                     │          │
                     │          ├──→ pertes Joule ↑
                     │          │
                     │          └──→ échauffement ↑
                     │
                     ├──→ transfo davantage chargé
                     │
                     ├──→ câbles davantage chargés
                     │
                     └──→ capacité disponible ↓
                               
                         ↓
                  CAPEX / OPEX ↑

- Oui — voici une fiche de référence compacte mais complète, conçue pour être sauvegardée telle quelle en `.md`.

# Puissance réactive, facteur de puissance et régulation de tension

## 1. Grandeurs fondamentales

La puissance complexe est :

$$
\boxed{S=P+jQ}
$$

avec :

* \(P\) : puissance active [W]
* \(Q\) : puissance réactive [var]
* \(S=|S|\) : puissance apparente [VA]

Relation :

$$
\boxed{S^2=P^2+Q^2}
$$

Le facteur de puissance est :

$$
\boxed{FP=\cos\varphi=\frac{P}{S}}
$$

et :

$$
\boxed{\tan\varphi=\frac{Q}{P}}
$$

Donc :

$$
\boxed{FP=\frac{1}{\sqrt{1+\tan^2\varphi}}}
$$

et :

$$
\boxed{\tan\varphi=\frac{\sqrt{1-FP^2}}{FP}}
$$

### Interprétation

Pour une charge inductive :

$$
Q>0
$$

Pour une charge capacitive :

$$
Q<0
$$

Un mauvais FP signifie qu'une part importante du courant sert à transporter de la puissance réactive plutôt que de la puissance active.

---

# 2. Pourquoi la puissance réactive est importante

La puissance réactive ne correspond pas à une consommation nette d'énergie comme \(P\), mais elle est nécessaire au fonctionnement de nombreux équipements :

* moteurs asynchrones ;
* transformateurs ;
* inductances ;
* alternateurs ;
* certains convertisseurs ;
* réseaux électriques eux-mêmes.

Elle provoque néanmoins un courant supplémentaire.

En triphasé :

$$
\boxed{I=\frac{S}{\sqrt3 V}}
$$

avec :

$$
S=\frac{P}{FP}
$$

donc :

$$
\boxed{I=\frac{P}{\sqrt3 V\,FP}}
$$

À puissance active \(P\) et tension \(V\) constantes :

$$
\boxed{I\propto\frac{1}{FP}}
$$

---

# 3. Pourquoi un mauvais FP coûte de l'argent même sans pénalité

## 3.1 Pertes Joule

Les pertes dans une résistance sont :

$$
\boxed{P_J=3RI^2}
$$

Or :

$$
I=\frac{P}{\sqrt3 V\,FP}
$$

donc :

$$
\boxed{
P_J=\frac{RP^2}{V^2FP^2}
}
$$

À puissance active constante :

$$
\boxed{P_J\propto\frac{1}{FP^2}}
$$

Exemple :

* FP = 1 → courant minimal ;
* FP = 0,8 → courant multiplié par \(1/0,8=1,25\) ;
* pertes Joule multipliées par \(1,25^2=1,56\).

Donc une mauvaise compensation peut augmenter sensiblement les pertes électriques.

---

## 3.2 Câbles et transformateurs

Le mauvais FP augmente :

$$
S=\frac{P}{FP}
$$

Donc pour fournir la même puissance active, il faut davantage de capacité en :

* A ;
* kVA ;
* MVA.

Conséquences :

* plus de courant dans les câbles ;
* davantage de pertes ;
* échauffement plus important ;
* capacité disponible des transformateurs réduite ;
* possibilité de devoir surdimensionner câbles et transformateurs.

Le problème n'est donc pas uniquement la facture de réactif.

---

# 4. Quels équipements consomment ou produisent du réactif ?

## Consommateurs de réactif

Principalement les équipements inductifs :

* moteurs asynchrones ;
* transformateurs ;
* inductances ;
* pompes et ventilateurs entraînés par moteurs ;
* compresseurs ;
* machines tournantes ;
* certaines soudures et fours ;
* certains convertisseurs selon leur architecture et leur commande.

Une machine tournante vieillissante peut présenter une dérive de \(Q\) pour plusieurs raisons : variation des conditions de fonctionnement, augmentation des pertes, dégradation mécanique ou magnétique, fonctionnement hors point nominal, etc. Il faut cependant diagnostiquer la cause : une hausse de \(Q\) n'est pas automatiquement due au vieillissement.

## Sources de réactif capacitif

* batteries de condensateurs ;
* câbles et lignes électriques ;
* filtres capacitifs ;
* SVC ;
* STATCOM ;
* certains onduleurs ;
* alternateurs pouvant fournir ou absorber du réactif selon leur excitation.

---

# 5. Pourquoi \(Q\) influence la tension

Une ligne peut être représentée approximativement par :

$$
\boxed{Z=R+jX}
$$

L'équation de la ligne est :

$$
\boxed{\underline V_s=\underline V_r+(R+jX)\underline I}
$$

À la réception :

$$
\boxed{\underline S=\underline V_r\underline I^*=P+jQ}
$$

En prenant \(V_r\) comme référence :

$$
\boxed{
\underline I=\frac{P-jQ}{V_r}
}
$$

Donc :

$$
\underline V_s
=
V_r+
(R+jX)\frac{P-jQ}{V_r}
$$

Après développement :

$$
\boxed{
\underline V_s=
V_r+
\frac{RP+XQ}{V_r}
+j\frac{XP-RQ}{V_r}
}
$$

---

# 6. Approximation de chute de tension

La formule exacte du module est :

$$
V_s=
\sqrt{
\left(
V_r+\frac{RP+XQ}{V_r}
\right)^2
+
\left(
\frac{XP-RQ}{V_r}
\right)^2
}
$$

On suppose une faible chute de tension :

$$
|\Delta V|\ll V
$$

Les termes quadratiques sont alors négligeables au premier ordre.

On obtient :

$$
\boxed{
\Delta V=V_s-V_r
\approx
\frac{RP+XQ}{V_r}
}
$$

ou, selon la convention de signe :

$$
\boxed{
V_r-V_s
\approx
-\frac{RP+XQ}{V_r}
}
$$

### Point mathématique important

Si :

$$
\underline V_s=(V_r+a)+jb
$$

alors :

$$
V_s=\sqrt{(V_r+a)^2+b^2}
$$

Le terme \(a\) apparaît au **premier ordre** :

$$
V_s\approx V_r+a
$$

alors que \(b\) apparaît dans le module sous la forme :

$$
b^2
$$

donc au **deuxième ordre**.

On ne néglige donc pas le terme réel : on conserve le terme réel de premier ordre et on néglige les contributions quadratiques.

---

# 7. Pourquoi Q agit fortement sur V

La variation liée à \(Q\) est :

$$
\boxed{
\Delta V_Q\approx\frac{XQ}{V}
}
$$

Donc :

$$
\boxed{
\frac{\partial V}{\partial Q}\approx-\frac{X}{V}
}
$$

pour la convention \(V_r-V_s\).

Ainsi, dans un réseau principalement inductif :

$$
\boxed{
Q\uparrow\Rightarrow V\downarrow
}
$$

et :

$$
\boxed{
Q_{capacitif}\uparrow\Rightarrow V\uparrow
}
$$

On peut résumer :

$$
Q\uparrow
\rightarrow I_Q\uparrow
\rightarrow XI_Q\uparrow
\rightarrow \text{chute de tension}\uparrow
\rightarrow V\downarrow
$$

---

# 8. Rôle de P et Q dans la tension

La formule :

$$
\boxed{
\Delta V\approx\frac{RP+XQ}{V}
}
$$

montre deux contributions :

$$
\boxed{\Delta V_P\approx\frac{RP}{V}}
$$

$$
\boxed{\Delta V_Q\approx\frac{XQ}{V}}
$$

Dans les réseaux où :

$$
X\gg R
$$

l'effet de \(Q\) domine souvent :

$$
\boxed{
\Delta V\approx\frac{XQ}{V}
}
$$

Mais ce n'est pas universel.

Dans les réseaux basse tension avec un rapport \(R/X\) élevé, la puissance active \(P\) peut avoir une influence importante sur la tension.

---

# 9. Une dérive de Q peut-elle provoquer une dérive de V ?

Oui.

Si :

$$
Q\uparrow
$$

alors, toutes choses égales par ailleurs :

$$
\boxed{V\downarrow}
$$

Une dérive typique peut être :

```text
Charge inductive ↑
       ↓
     Q ↑
       ↓
Courant réactif ↑
       ↓
Chute de tension ↑
       ↓
     V ↓
```

Mais le système est couplé :

$$
V=f(P,Q,\text{réseau})
$$

et :

$$
Q=f(V,\text{charge},\text{équipement})
$$

Donc une variation de tension peut également modifier \(Q\).

Une dérive de \(Q\) et une dérive de \(V\) peuvent donc former une boucle.

---

# 10. Comment réguler la tension

Le principe général est une boucle fermée :

$$
V_{mesuré}
\rightarrow
\text{comparaison avec }V_{ref}
\rightarrow
\text{commande}
\rightarrow
\text{action sur le réseau}
\rightarrow
V
$$

## 10.1 Compensation réactive

Si :

$$
V<V_{ref}
$$

on peut injecter du réactif capacitif :

$$
Q<0
$$

ce qui tend à faire remonter la tension.

Moyens :

* condensateurs ;
* SVC ;
* STATCOM ;
* contrôle du réactif des onduleurs ;
* contrôle de l'excitation des alternateurs.

---

## 10.2 Transformateur avec OLTC

Un transformateur à prises en charge :

$$
\boxed{OLTC}
$$

modifie son rapport de transformation pour ajuster la tension secondaire.

Très adapté aux variations lentes.

---

## 10.3 Régulation rapide

Pour les variations rapides :

* SVC ;
* STATCOM ;
* convertisseurs ;
* contrôle dynamique des onduleurs.

Une architecture industrielle peut donc combiner :

$$
\boxed{
STATCOM/SVC\rightarrow variations rapides
}
$$

et :

$$
\boxed{
OLTC\rightarrow variations lentes
}
$$

---

# 11. Réglementation française : réactif en HTA

Pour les sites concernés par le dispositif de soutirage HTA du **TURPE 7**, le seuil de référence est :

$$
\boxed{\tan\varphi=0,40}
$$

Le dépassement est concerné par la facturation pendant les périodes tarifaires prévues.

Le seuil :

$$
\tan\varphi=0,40
$$

correspond à :

$$
FP=
\frac{1}{\sqrt{1+0,4^2}}
$$

soit environ :

$$
\boxed{FP=0,928}
$$

Donc :

> \(\tan\varphi=0,4\) ne signifie absolument pas \(FP=0,4\).

Pour le TURPE 7, le dispositif concerne notamment les **heures de pointe et heures pleines de saison haute**, la saison haute correspondant à **novembre à mars**.

Le tarif indiqué dans la documentation tarifaire Enedis pour le soutirage HTA concerné est de :

$$
\boxed{2,44\;c€/kVArh}
$$

Source de référence :

* Enedis — brochure tarifaire TURPE 7 :
  [https://www.enedis.fr/sites/default/files/documents/pdf/brochure-tarifaire-turpe-7.pdf](https://www.enedis.fr/sites/default/files/documents/pdf/brochure-tarifaire-turpe-7.pdf)

Attention : les règles tarifaires évoluent. Toujours vérifier la version actuelle du TURPE et les conditions exactes du contrat de raccordement.

---

# 12. Indicateurs à suivre dans une usine

Les KPI importants sont :

### Électriques

$$
\boxed{P\;(kW/MW)}
$$

$$
\boxed{Q\;(kVAr/MVAr)}
$$

$$
\boxed{S\;(kVA/MVA)}
$$

$$
\boxed{FP}
$$

$$
\boxed{\tan\varphi}
$$

$$
\boxed{V}
$$

$$
\boxed{I}
$$

### Énergétiques

$$
\boxed{kWh}
$$

$$
\boxed{kVArh}
$$

### Qualité réseau

$$
\boxed{THD_V}
$$

$$
\boxed{THD_I}
$$

harmoniques individuelles, déséquilibre, creux/surtensions, flicker selon les besoins.

### KPI de pilotage

Part du temps où :

$$
\boxed{\tan\varphi>0,4}
$$

pendant les périodes concernées.

Et surtout :

$$
\boxed{kVArh_{\text{facturables}}}
$$

et :

$$
\boxed{\text{coût associé en €}}
$$

---

# 13. Que mesurer et à quel pas de temps ?

## Pour Energy Management / analyse

Mesurer :

* \(P\)
* \(Q\)
* \(S\)
* \(V\)
* \(I\)
* FP
* tan φ
* kWh
* kVArh
* horodatage

Un pas de :

$$
\boxed{10\;min}
$$

est particulièrement pertinent pour le suivi énergétique et la comparaison avec les données de comptage.

## Pour le contrôle

10 min n'est pas suffisant.

La régulation de condensateurs, SVC, STATCOM, etc. utilise des mesures beaucoup plus rapides :

* secondes ;
* centaines de millisecondes ;
* millisecondes selon la technologie et le phénomène étudié.

Donc :

$$
\boxed{
10\;min=\text{Energy Management / analyse}
}
$$

$$
\boxed{
\text{mesure rapide}=\text{contrôle / qualité réseau}
}
$$

---

# 14. Solutions de compensation

## Compensation centralisée

Batterie de condensateurs au niveau du TGBT ou du poste.

Avantages :

* simple ;
* centralisée ;
* facile à superviser ;
* adaptée à une charge globale variable.

Inconvénient :

le courant réactif circule encore dans le réseau interne jusqu'au point de compensation.

---

## Compensation locale

Condensateur installé au plus près de la charge inductive.

Exemple :

```text
Transformateur
      |
      +------ Moteur
      |         |
      |      Condensateur
      |
      +------ autres charges
```

Avantage :

$$
Q_{\text{réseau local}}\downarrow
$$

donc :

$$
I_{\text{réseau local}}\downarrow
$$

et les pertes diminuent.

Particulièrement intéressant pour les gros moteurs relativement stables.

---

## Compensation hybride

Souvent la solution industrielle la plus intéressante :

$$
\boxed{
\text{compensation locale des grosses charges}
+
\text{compensation automatique centrale}
}
$$

---

# 15. Batterie fixe vs automatique

## Batterie fixe

Adaptée lorsque :

$$
Q(t)\approx constante
$$

Exemple : gros moteur fonctionnant avec une charge relativement stable.

## Batterie automatique

Adaptée lorsque :

$$
Q(t)=\text{variable}
$$

Le contrôleur mesure :

$$
P,Q,FP
$$

et connecte/déconnecte des gradins de condensateurs.

Exemple :

* 100 kVAr ;
* 100 kVAr ;
* 200 kVAr ;
* 400 kVAr.

La régulation cherche à maintenir :

$$
FP\approx FP_{cible}
$$

ou :

$$
\tan\varphi\approx\tan\varphi_{cible}
$$

---

# 16. Attention à la surcompensation

Il ne faut pas chercher automatiquement :

$$
FP=1
$$

à tout instant.

Une compensation excessive peut conduire à :

$$
Q<0
$$

et donc à un fonctionnement capacitif.

Cela peut provoquer :

* surtension ;
* circulation de réactif capacitif ;
* problèmes de résonance ;
* contraintes sur les équipements ;
* problèmes de qualité d'énergie.

La cible doit donc être optimisée, pas simplement maximisée.

---

# 17. Attention aux harmoniques

Dans une usine comportant beaucoup de :

* variateurs ;
* redresseurs ;
* UPS ;
* convertisseurs ;
* bornes de recharge ;
* alimentations électroniques ;

il faut analyser :

$$
THD_I
$$

et :

$$
THD_V
$$

avant d'installer une batterie de condensateurs.

Une batterie classique peut interagir avec l'impédance du réseau et créer des phénomènes de résonance.

Solutions possibles :

* batteries désaccordées ;
* filtres passifs ;
* filtres actifs ;
* STATCOM ;
* architectures hybrides.

---

# 18. Ordres de grandeur du FP

Correspondances utiles :

|   FP | tan φ |
| ---: | ----: |
| 0,80 | 0,750 |
| 0,85 | 0,620 |
| 0,90 | 0,484 |
| 0,93 | 0,395 |
| 0,95 | 0,329 |
| 0,97 | 0,251 |
| 0,98 | 0,203 |
| 0,99 | 0,143 |
| 1,00 |     0 |

En pratique industrielle, une cible typique peut être :

$$
\boxed{FP\approx0,95-0,99}
$$

avec une marge suffisante vis-à-vis des contraintes tarifaires et techniques.

Il n'est généralement pas nécessaire de maintenir exactement :

$$
FP=1
$$

---

# 19. Architecture complète d'un Energy Management System

Une architecture industrielle typique peut être :

```text
                RÉSEAU
                   |
             Compteur HTA
                   |
          +--------+--------+
          |                 |
       Mesures           Protection
          |
     P Q V I FP
          |
        SCADA
          |
        Historian
          |
        EMS / Data
          |
   +------+-------+---------+
   |              |         |
Analyse FP      Analyse Q   Analyse V
   |              |         |
   +------+-------+---------+
          |
      Optimisation
          |
   +------+------+---------+
   |             |         |
OLTC        Batterie     STATCOM
            condensateurs
          |
          ↓
       Réseau
          |
      V, Q, P
          |
       feedback
```

L'objectif n'est donc pas simplement :

> « améliorer le facteur de puissance ».

Il s'agit de gérer simultanément :

$$
\boxed{
P,\;Q,\;V,\;I,\;S,\;FP,\;THD,\;\text{coût}
}
$$

---

# 20. Chaîne physique complète à retenir

Le raisonnement fondamental est :

$$
\boxed{
Q\uparrow
}
$$

$$
\Downarrow
$$

$$
\boxed{
I_Q=\frac{Q}{V}\uparrow
}
$$

$$
\Downarrow
$$

$$
\boxed{
I\uparrow
}
$$

$$
\Downarrow
$$

$$
\boxed{
P_J=3RI^2\uparrow
}
$$

et simultanément :

$$
\boxed{
\Delta V\approx\frac{RP+XQ}{V}
}
$$

donc :

$$
\boxed{
V\downarrow
}
$$

On obtient donc :

$$
\boxed{
\text{Q élevé}
\rightarrow
\text{courant élevé}
\rightarrow
\text{pertes élevées}
+
\text{chute de tension}
+
\text{capacité réseau consommée}
}
$$

La compensation agit en sens inverse :

$$
\boxed{
Q_{\text{compensation}}\downarrow Q_{\text{réseau}}
\rightarrow
I\downarrow
\rightarrow
P_J\downarrow
\rightarrow
V\uparrow
}
$$

---

# 21. Les 10 points à mémoriser

1. \(\boxed{S=P+jQ}\)
2. \(\boxed{S^2=P^2+Q^2}\)
3. \(\boxed{FP=P/S=\cos\varphi}\)
4. \(\boxed{\tan\varphi=Q/P}\)
5. \(\boxed{I=P/(\sqrt3 V FP)}\)
6. \(\boxed{P_J=3RI^2}\)
7. \(\boxed{\Delta V\approx(RP+XQ)/V}\)
8. Dans un réseau inductif, \(\boxed{Q\uparrow\Rightarrow V\downarrow}\)
9. Le réactif se contrôle principalement par \(\boxed{\text{condensateurs, SVC, STATCOM, excitation et onduleurs}}\)
10. En industrie, surveiller simultanément \(\boxed{P,Q,V,I,FP,\tan\varphi,kWh,kVArh,THD}\)

## Sources principales

* Enedis — documentation tarifaire TURPE 7 :
  [https://www.enedis.fr/sites/default/files/documents/pdf/brochure-tarifaire-turpe-7.pdf](https://www.enedis.fr/sites/default/files/documents/pdf/brochure-tarifaire-turpe-7.pdf)
* Commission de régulation de l'énergie — TURPE 7 :
  [https://www.cre.fr/electricite/turpe/turpe-7.html](https://www.cre.fr/electricite/turpe/turpe-7.html)
* IEC 60038 — Standard voltages :
  [https://webstore.iec.ch/en/publication/72877](https://webstore.iec.ch/en/publication/72877)
* IEC 61000 — Electromagnetic compatibility / voltage fluctuations and flicker :
  [https://webstore.iec.ch/](https://webstore.iec.ch/)




