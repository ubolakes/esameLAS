#!/bin/bash
# per ogni file che modifico inserisco una riga nel formato:
#mkdir -p #<path-nella-forma-richiesta>
#scp -F /home/umberto/Scrivania/LabAmm/<nome-dir-della-VM>/ssh.conf default:<path-file-sulla-VM> <path-nella-macchina-host>
#esempio reale:
#mkdir -p Client/attivita1/etc/network/ #<path-nella-forma-richiesta>
#scp -F /home/umberto/Scrivania/LabAmm/R1/ssh.conf default:/etc/network/interfaces Client/attivita1/etc/network/

#File client
mkdir -p Client/attivita1/etc/network/ #<path-nella-forma-richiesta>
scp -F /home/umberto/Scrivania/esame_2021_6_14/Client/ssh.conf default:/etc/network/interfaces Client/attivita1/etc/network/

#File Router
mkdir -p Router/attivita1/etc/network/ #<path-nella-forma-richiesta>
scp -F /home/umberto/Scrivania/esame_2021_6_14/Router/ssh.conf default:/etc/network/interfaces Router/attivita1/etc/network/
mkdir -p Router/attivita1/etc/ #<path-nella-forma-richiesta>
scp -F /home/umberto/Scrivania/esame_2021_6_14/Router/ssh.conf default:/etc/dnsmasq.conf Router/attivita1/etc/
mkdir -p Router/attivita1/etc/ #<path-nella-forma-richiesta>
scp -F /home/umberto/Scrivania/esame_2021_6_14/Router/ssh.conf default:/etc/sysctl.conf Router/attivita1/etc/
mkdir -p Router/attivita3/ #<path-nella-forma-richiesta>
scp -F /home/umberto/Scrivania/esame_2021_6_14/Router/ssh.conf default:/etc/snmp/snmpd.conf Router/attivita3/


#File Server1
mkdir -p Server1/attivita1/etc/network/ #<path-nella-forma-richiesta>
scp -F /home/umberto/Scrivania/esame_2021_6_14/Server1/ssh.conf default:/etc/network/interfaces Server1/attivita1/etc/network/
mkdir -p Server1/attivita2/ #<path-nella-forma-richiesta>
scp -F /home/umberto/Scrivania/esame_2021_6_14/Server1/ssh.conf default:/home/vagrant/ldap.sh Server1/attivita2/
mkdir -p Server1/attivita2/ #<path-nella-forma-richiesta>
scp -F /home/umberto/Scrivania/esame_2021_6_14/Server1/ssh.conf default:/home/vagrant/failback.sh Server1/attivita2/

#File Server2
mkdir -p Server2/attivita1/etc/network/ #<path-nella-forma-richiesta>
scp -F /home/umberto/Scrivania/esame_2021_6_14/Server2/ssh.conf default:/etc/network/interfaces Server2/attivita1/etc/network/

#playbook di ansible
mkdir -p Ansible/playbook/
cp /home/umberto/Scrivania/esame_2021_6_14/Client/playbook_client.yml Ansible/playbook/
cp /home/umberto/Scrivania/esame_2021_6_14/Router/playbook_client.yml Ansible/playbook/
cp /home/umberto/Scrivania/esame_2021_6_14/Server1/playbook_client.yml Ansible/playbook/
cp /home/umberto/Scrivania/esame_2021_6_14/Server2/playbook_client.yml Ansible/playbook/

#Copia di bash_history
mkdir -p bash_history/
scp -F /home/umberto/Scrivania/esame_2021_6_14/Client/ssh.conf default:/home/vagrant/.bash_history bash_history/
scp -F /home/umberto/Scrivania/esame_2021_6_14/Router/ssh.conf default:/home/vagrant/.bash_history bash_history/
scp -F /home/umberto/Scrivania/esame_2021_6_14/Server1/ssh.conf default:/home/vagrant/.bash_history bash_history/
scp -F /home/umberto/Scrivania/esame_2021_6_14/Server2/ssh.conf default:/home/vagrant/.bash_history bash_history/


# creo un archivio tar dei file
# devo essere nella dir indicata
tar cf esame.tar *
# l'archivio viene creato nella directory indicata nel comando
