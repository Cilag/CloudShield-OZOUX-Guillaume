============================================================
LIVRABLE 4 - CAHIER DE RECETTE : 10 PREUVES TECHNIQUES ANSSI
Projet Cloud Shield - FinTech Global
Auteur : Guillaume OZOUX - Avril 2026
============================================================

Placez vos 10 captures d'ecran dans ce dossier avec les noms suivants :

Capture_01_Segmentation_VNet_Hub.png
  -> Regle ANSSI 19 : VNet Hub 10.10.0.0/16 avec 4 subnets
  -> Portail Azure > vnet-cloudshield-hub > Overview

Capture_02_NSG_Web_Regles_ASG.png
  -> Regle ANSSI 19 : Micro-segmentation avec NSG et ASG
  -> Portail Azure > nsg-web > Inbound/Outbound rules

Capture_03_Blocage_Web_vers_DB.png
  -> Regle ANSSI 19 + Zero Trust : Mouvement lateral impossible
  -> Terminal Bastion > vm-web-01 : ping/ssh/curl vers 10.20.3.4 = timeout

Capture_04_Flux_Web_vers_App_8080.png
  -> Regle ANSSI 22 : Moindre privilege - seul flux metier autorise
  -> Terminal Bastion > vm-web-01 : curl http://10.20.2.4:8080 = app-tier-ok

Capture_05_Filtrage_App_vers_DB_3306.png
  -> Regle ANSSI 22 : Filtrage strict par port
  -> Terminal Bastion > vm-app-01 : port 3306 ouvert, port 80 bloque

Capture_06_VM_Sans_IP_Publique.png
  -> Regle ANSSI 28 : Pas d'IP publique sur les VMs de production
  -> Portail Azure > vm-web-01 > Overview : Public IP = -

Capture_07_Session_Bastion_SSH.png
  -> Regle ANSSI 28+30 : Administration securisee via Bastion
  -> Portail Azure > vm-web-01 > Bastion + session SSH ouverte

Capture_08_Private_Endpoint_Storage.png
  -> Regle ANSSI 25 : Private Endpoint pour le Storage PaaS
  -> Portail Azure > pe-stbackup-blob : IP privee, Connection Approved

Capture_09_Peering_Hub_Spoke.png
  -> Regle ANSSI 19 : Centralisation Hub-and-Spoke
  -> Portail Azure > vnet-cloudshield-hub > Peerings = Connected

Capture_10_Route_Table_Web.png
  -> Regle ANSSI 36 : Route Tables pour controle du trafic sortant
  -> Portail Azure > rt-web : associe a snet-web + nsg-web
