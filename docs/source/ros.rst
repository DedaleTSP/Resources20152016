***
ROS
***

Introduction
############

ROS est un framework dédié à la robotique. Le choix d'utiliser ROS pour notre projet vient du fait qu'ayant du repartir
de 0 au mois de Mars, il nous fallait gagner du temps sur la réalisation de notre solution. L'intéret réside dans le fait
que pour ce framework existe un nombre important de paquets, notamment un driver pour l'ardrone et un paquet de
reconnaissance de tags. Nous n'avions donc plus à coder l'interface avec le matériel, et la reconnaissance de formes,
mais à les faire intéragir entre eux.

Installation
############

Installer ROS
*************

ROS peut être compliqué à installer à première vue, notamment lorsqu'on se lance dans son installation depuis les sources.
La méthode la plus simple et la plus sûr (perdre du temps sur cette étape n'est vraiment pas intéressant) consiste à
l'installer depuis des paquets binaires disponible dans les dépots des distributions officiellement supportées par ROS.
A ce jour, uniquement Ubuntu et ses variantes.
D'où l'utilité d'avoir une raspberry 2 ou plus pour pouvoir y installer le système ``Ubuntu-ARM``.
ROS est disponible sous plusieurs versions. A ce jour, ``ROS indigo`` est la version avec le plus de compatibilité, et
est disponible sur ``Ubuntu 14.04 (Desktop)`` au maximum. Lors du choix de la version de ROS, il faut faire attention à
ce que tout les paquets ROS que l'on projette d'utiliser soit nativement compatibles avec cette versions (pour encore
une fois éviter les installations depuis les sources).

Plus de détails sur l'installation de ROS sur la documentation officielle `ici <http://wiki.ros.org/fr/ROS/Installation>`_

Installer un paquet ROS depuis les dépots Ubuntu
************************************************

Pour tous les paquets, la procédure d'installation est indiquée dans la documentation. Lorsque le paquet est disponible
sur les dépots Ubuntu, il suffit pour l'installer de lancer :

    .. code-block:: bash

        $ sudo apt-get install ros-indigo-ardrone-autonomy

Créer un espace de travail
**************************

Un espace de travail ROS est nécéssaire au développement de paquets. Pour initialiser un espace de travail, la démarche
est disponible sur la documentation officielle `ici <http://wiki.ros.org/catkin/Tutorials/create_a_workspace>`_

Installer un paquet depuis les sources
**************************************

Pour installer un paquet depuis les sources, il faut charger les sources dans le répertoire ``catkin_ws/src/`` puis
la depuis le répertoire ``catkin_ws`` lancer les commande

    .. code-block:: bash

        $ catkin_make
        $ source ~/catkin_ws/devel/setup.bash

Comprendre ROS
##############

ROS utilise une structure particulière qui lui est propre. Un programme est constitué de ``noeuds`` qui s'échangent des
informations ``messages`` à travers des ``topics``.
Un programme peut être lancé via un fichier de lancement ``launch`` ou directement en lançant le noeud (archaïque).
Différents outils en ligne de commande permettent de manipuler ROS, notamment ``roslaunch`` qui permet de lancer un fichier
``launch``, et ``rostopic`` qui permet d'intéragir directement avec les topics ouvert par un noeud (leur envoyer des messages
ou recevoir ce qu'ils émettent).
Pour plus d'informations, utilisez la commande ``man``

Lancer un fichier de démarrage
******************************

Une fois un paquet installé, les fichiers de démmarage sont disponible dans son répertoire racine sous ``/launch``.
Pour executer une fichier de démarrage :

    .. code-block:: bash

        $ roslaunch [PackageName] [LaunchFile]

Par exemple :

    .. code-block:: bash

        $ roslaunch ardrone_autonomy ardrone_driver.launch

Utilisation du paquet ROS 2015-2016
###################################

Le paquet ROS écrit en 2015-2016 peut être installé et utilisé suivant la procédure (nécessite ROS indigo d'installé et
un espace de travail catkin sous ``~/catkin_ws/``

**Installer les dépendances**
    .. code-block::

        $ sudo apt-get install ros-indigo-ardrone-autonomy ros-indigo-ar-track-alvar

**Installer le paquet**
    .. code-block::

        $ cd ~/catkin_ws/src/
        $ git clone "https://github.com/DedaleTSP/ddale_ardrone_nav"
        $ cd ~/catkin_ws/
        $ catkin_make
        $ source ~/catkin_ws/devel/setup.bash

**Lancer le programme**
    .. code-block::

        $ roslaunch ddale_ardrone_nav ardrone_navigation.launch

Développement
#############

Pour le développement et l'utilisation générale de ROS, la documentation officielle est très bien faite : `ici <http://wiki.ros.org/fr/ROS/Tutorials>`_
Une grande aide pour le développement est la consultation d'exemples dans les sources d'autres paquets.

- `falkor_ardrone <https://github.com/FalkorSystems/falkor_ardrone>`_
- `tum_ardrone <http://www.ros.org/wiki/tum_ardrone>`_
- `arl_ardrone_examples <https://github.com/parcon/arl_ardrone_examples>`_
- `AR Drone Tutorials <https://github.com/mikehamer/ardrone_tutorials>`_
- `tum_simulator <http://wiki.ros.org/tum_simulator>`_

Enfin, la documentation du paquet ``ardrone_autonomy`` est très complète et disponible `ici <http://ardrone-autonomy.readthedocs.io/>`_

Liens externes
##############

Installer ROS sur Ubuntu : `ici <http://wiki.ros.org/fr/ROS/Installation>`_
Initialiser un espace de travail : `ici <http://wiki.ros.org/catkin/Tutorials/create_a_workspace>`_
Tuto ROS : `ici <http://wiki.ros.org/fr/ROS/Tutorials>`_
