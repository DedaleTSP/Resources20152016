************
Raspberry Pi
************

Utilité
#######

La raspberry est l'ordinateur embarqué sur le drone. Elle s'y connecte et intéragit avec permettant le pilotage du
drone par un programme de façon autonome (sans station de base au sol). Elle est aussi utiliser pour étendre la portée
de connexion au drone. En effet, la raspberry pi est connectée sur le wifi du drone et sur le wifi du campus grâce à
ses deux interfaces, et donc accessible par un opérateur depuis le wifi du campus. Concrètement, il est possible d'agir
sur le drone dès lors que l'on est connecté au wifi du campus par le biais de la raspberry pi.

Installation
############

Le système de la raspberry est contenu sur une carte SD. Cette dernière est branchée dans le slot prévu à cet effet sur
la rapsberry pi. Les principaux systèmes disponibles sont : ``Raspbian`` ; ``ArchLinux-ARM`` ; ``Ubuntu-ARM``
(uniquement raspberry 2 et +). Le framework ROS utilisé pour le projet est disponible pour les trois précédents systèmes,
mais les paquets binaires uniquement sous ``Ubuntu-ARM``. Ainsi, dans le cas de ``Raspbian`` et ``ArchLinux-ARM``,
le framework ROS et tous les paquets associés doivent être compilés depuis les sources (et ce n'est pas une bonne idée,
les sources de beaucoup de paquets ROS ne sont plus maintenues après la release du paquet binaire sur Ubuntu). En bref,
le seule système officiellement supportée par ROS est Ubuntu, vouloir en utiliser un autre n'implique qu'une perte de
temps. (Il est même plus rapide de mettre en place une machine virtuelle sous Ubuntu et d'y installer ROS, que de vouloir
l'installer sur un autre système où il n'est pas nativement supporté). Pour en revenir à l'installation d'un système sur
raspberry pi, une fois en possession d'une carte SD et d'une image système pour le modèle de raspberry pi, il suffit
de faire un :

    .. code-block:: bash

        $ dd if="/chemin/vers/fichier/image" of="/dev/sdX"

Avec ``/dev/sdX`` le chemin vers la carte SD. Pour obtenir ce chemin, la commande ``lsblk`` est utile.
Pour plus d'informations, voir les pages ``man`` des différentes commandes utilisées, et la documentation officielle
des raspberry pi : `Installer un système sur sa raspberry pi <https://www.raspberrypi.org/documentation/installation/installing-images/linux.md>`_

Usage
#####

Pour accéder à la raspberry pi depuis un autre ordinateur, l'interface la plus utilisé est le ``ssh``.
Elle est accessible dès lors que la raspberry et l'ordinateur sont en réseau, et ouvre un terminal distant sur la
raspberry depuis l'ordinateur, permettant pleinement de s'en servir. Il suffit, depuis un terminal, de lancer la commande :

    .. code-block:: bash

        $ ssh [user]@[hostnameORIPadress]

Dans le cas de la raspberry pi, l'utilisateur par défaut est ``pi``, le nom d'hôte ``raspberrypi`` et l'addresse IP
varie selon le sous réseau dans lequel les deux appareils sont. Le mot de passe par défaut pour l'utilisateur ``pi`` est
``raspberry``. Un exemple concret serait (si la raspberry a 192.168.1.2 comme addresse IP) :

    .. code-block:: bash

        $ ssh pi@192.168.1.2

Pour plus d'informations, ``man ssh``.

Configuration
#############

Un certain nombre de configuration ont été faites sur la raspberry pi afin de faciliter son utilisation.

Démarrage
*********

L'utilisation de scripts de démarrage a été très utile dans notre projet, notamment un script permettant au démarrage
du système, d'envoyer un email contenant l'adresse IP de la raspberry pi (l'adresse pouvant changer à chaque redémarrages).
Il est possible de lancer un script au démarrage via la crontab. Elle est éditable en utilisant la commande :

    .. code-block:: bash

        $ crontab -e

et voici un exemple d'entrée dans la crontab :

    .. code-block:: crontab

        @reboot /home/pi/Dedale201516_RPI_Setup/startup.sh

qui lance le script ``startup.sh`` ayant pour code :

    .. code-block:: bash
        :linenos:

        #!/bin/sh
        wget --spider www.google.fr
        while [ "$?" != 0 ] ; do
	        sleep 2
	        wget --spider www.google.fr
        done
        while [ `cat /sys/class/net/wlan1/operstate` != "up" ] ; do
	        sleep 2
        done
        ip addr show wlan1 | mail -s "RaspberryIP" votreadresse@mail.com

Ce script essaye simplement de se connneter à google, et dès qu'il réussie, vérifie que l'interface wifi est bien
disponible, puis envoie par email sa configuration wifi vers l'adresse ``votreadresse@mail.com``

Réseau
******

La configuration réseau est certainement la plus importante, elle permet à la raspberry de communiquer avec le drone et
de se connecter au wifi du campus. Elle se fait via le fichier ``/etc/network/interfaces``. Nous utilisions ce fichier :

    .. code-block:: interfaces

        # Please note that this file is written to be used with dhcpcd.
        # For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'.

        auto lo
        iface lo inet loopback

        auto eth0
        allow-hotplug eth0
        iface eth0 inet static
            address 169.254.0.2
            netmask 255.255.255.0
            network 169.254.0.0
            broadcast 169.254.0.255

        auto wlan0
        allow-hotplug wlan0
        #iface wlan0 inet dhcp
        #wireless-essid ardrone2_090332

        auto wlan1
        allow-hotplug wlan1
        iface wlan1 inet dhcp
            pre-up wpa_supplicant -B -Dwext -i wlan1 -c /etc/wpa_supplicant/wpa_supplicant.conf
            post-down killall -q wpa_supplicant

L'interface eth0 est configurée pour une connexion ethernet statique, le wlan0 pour se connecter au drone, et le wlan1
pour se connecter au wifi du campus grâce au fichier de configuration ``wpa_supplicant`` que voici :

    .. code-block:: wpa_supplicant
        ctrl_interface=/var/run/wpa_supplicant
        ctrl_interface_group=0
        eapol_version=2
        ap_scan=1
        fast_reauth=1

        network={
            ssid="eduroam"
            scan_ssid=1
            key_mgmt=WPA-EAP
            eap=TTLS
            identity="username"
            password="password"
        }

A noter qu'à des fins de test, il est aussi possible de se connecter en réseau avec la raspberry pi en liaison ethernet
directe sans même avoir besoin de changer les fichiers de configuration présentés ci-dessus. C'est très utile lors de la
première configuration notamment. Pour celà, une fois une image système copiée sur la carte SD, il suffit de monter la
partition de la carte SD de 50mo ayant un système de fichier FAT/FAT32 (automatique sous Windows), puis d'éditer le
fichier ``cmdline.txt`` et d'ajouter à la fin de l'unique ligne du fichier : ``ip=169.254.0.2``. Ensuite, lors du
prochain démarrage, la raspberry se configurera en adressage statique sur son interface ethernet, il suffit alors avec
son ordinateur de se mettre en adressage statique avec l'adresse ``169.254.0.3`` par exemple. Il est ensuite possible
de se connecter à la raspberry en ssh via

    .. code-block:: bash

        $ ssh pi@169.254.0.2

Mails
*****

Dans la section démarrage, il était question d'envoyer un mail au démarrage de la raspberry pi contenant son adresse IP.
Les scripts disponible précédemment utilise la commande ``mail``. On détail ici sa configuration. Tout d'abord, il faut
installer les paquets nécessaires :

    .. code-block:: bash

        $ sudo apt-get install mailutils mpack
        $ sudo apt-get install ssmtp

Puis d'ajouter la configuration de ``ssmtp`` dans le fichier ``/etc/ssmtp/ssmtp.conf``. Voici le fichier utilisé cette année :

    .. code-block:: conf

        root=postmaster
        mailhub=mail
        hostname=raspberrypi

        root=ddedale2016@gmail.com
        mailhub=smtp.gmail.com:587
        hostname=srvweb
        AuthUser=ddedale2016@gmail.com
        AuthPass=*******
        FromLineOverride=YES
        UseSTARTTLS=YES

Il est ensuite possible d'envoyer un email de la façon suivante :

    .. code-block:: bash

        $ echo "Contenu du mail" | mail -s "Titre du mail" destinataire@gmail.com

Liens externes
##############

Une majorité des scripts inscrits dans cette page est disponible dans le dossier ``raspberrypi`` du dépot git : `Ici <https://github.com/DedaleTSP/Resources20152016>`_

