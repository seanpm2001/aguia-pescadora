echo "Este diário de bordo foi feito para ser visualizado, nao executado assim!"
exit

################### Diario de bordo: aguia-pescadora-delta ###################
# VPS (KVM), 6 vCPUs, 16GB RAM, 400GB SSD, Ubuntu Server 18.04 64bit, Contabo (Germany)
#
# Datacenter: Contabo, Germany
# Type: Virtual Machine, KVM
# OS: Ubuntu Server 18.04 LTS 64bit
# CPU: 6 vCPUs
# RAM: 16040 MB
# Disk: 400 GB
#
# IPv4: 173.249.10.99
# IPv6: 
# Domain:
#   Full: aguia-pescadora-delta.etica.ai (TTL: 15 min)
#   Short: apd.etica.ai (TTL: 15 min)
#
# -----------------------------------------------------------------------------#
# LICENSE: Public Domain
#   Except where otherwise noted, content on this server configuration and to
#   the extent possible under law, Emerson Rocha has waived all copyright and
#   related or neighboring rights to this work to Public Domain
#
# MAINTAINER: Emerson Rocha <rocha(at)ieee.org>
#   Keep in mind that several people help with suggestions, testing, bugfixes
#   and inspiration without get names noted in places that most software
#   developers look. I'm saying this in special for people who help over
#   Facebook discussions. Even the ones without a personal computer yet and/or
#   with limited access to internet.
#
# SECURITY:
#   Reporting a Vulnerability:
#   Send e-mail to Emerson Rocha: rocha(at)ieee.org.
################################################################################

### Primeiro login______________________________________________________________
# Você, seja por usuario + senha, ou por Chave SSH, normlamente terá que acessar
# diretamente como root. Excessões a esta regra (como VMs na AWS) geralmente
# implicam em logar em um usuario não-root e executar como sudo. Mas nesta da
# é por root mesmo nesse momento.
ssh root@173.249.10.99
ssh root@aguia-pescadora-delta.etica.ai

### Atualizar o sistema operacional_____________________________________________
# O sistema operacional (neste caso, Ubuntu) normalmente não vai estar 100%
# atualizado. Os comandos abaixo são uma boa prática pra fazer imediatamente
sudo apt update
sudo apt upgrade -y
sudo apt autoremove

### Define um hostname personalizado____________________________________________
# O hostname padrão geralmente não faz muito sentido pra você e os usuparios
# da VPS. No nosso caso, era vps240016, como em root@vps240016.
# Nota: o domínio 'aguia-pescadora-bravo.etica.ai' já aponta para 192.99.247.117
sudo hostnamectl set-hostname aguia-pescadora-delta.etica.ai

# Edite /etc/hosts e adicione o hostname também apontando para 127.0.0.1
sudo vi /etc/hosts
## Adicione
# 127.0.0.1 aguia-pescadora-delta.etica.ai  aguia-pescadora-delta

### Define horário padrão de sistema____________________________________________
# Vamos definir como horário padrão de servidor o UTC.
# Motivo 1: para aplicações de usuário, é mais fácil calcular a partir do horário
#           Zulu
# Motivo 2: Este servidor será acessado por pessoas de diversos países, não
#           apenas falantes de português que são do Brasil (e que, aliás, o
#           próprio Brasil tem mais de um fuso horário)
sudo timedatectl set-timezone UTC

### Adiciona ao menos uma chave de administrador _______________________________
# Para fazer acesso sem senha de root (e uma chave extra além da usada 
# inicialmente pelo Tsuru)

## O comando a seguir é executado da sua maquina local, não no servidor!
ssh-copy-id -i ~/.ssh/id_rsa-rocha-eticaai-2019.pub root@aguia-pescadora-delta.etica.ai

## TODO: remover o language-pack-pt de Delta. Usuarios finais
#        não irão acessar o host, e até mesmo administradores tenderão
#        fortemente a apenas usar o Tsuru (fititnt, 2019-06-16 01:44 BRT)

### Criar Swap & ajusta Swappiness______________________________________________
## TODO: setup swap from 2GB (defalt from Contabo) to 16GB (fititnt, 2019-06-12 08:55 BRT)

## Já temos uma Swap de 2GB
# root@aguia-pescadora-delta:/# ls -lh /swapfile
# -rw------- 1 root root 2.0G Jun 12 11:05 /swapfile

## @see https://bogdancornianu.com/change-swap-size-in-ubuntu/
## @see https://askubuntu.com/questions/1075505/how-do-i-increase-swapfile-in-ubuntu-18-04/1075516#1075516

## Cria um /swapfile de 4GB
# @see https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-18-04
# @see https://askubuntu.com/questions/1075505/how-do-i-increase-swapfile-in-ubuntu-18-04/1075516#1075516

# TODO: descobrir configurações para rodar Tsuru em produção que estejam
#       relacionadas a swap. Numa olhada rápida ao menos quando usado
#        Kubernetes (que NÃO é nosso caso) os desenvolvedores desativam
#        funcionamento em sistemas com Swap sem parametro especial, vide
#        https://github.com/kubernetes/kubernetes/issues/53533
#        (fititnt, 2019-06-17 02:16 BRT)

#------------------------------------------------------------------------------#
# SEÇÃO TSURU: ADIÇÃO DA CHAVE SSH PARA SER CONFIGURADO REMOTAMENTE            #
#                                                                              #
# AVISO: veja devel-fititnt-bravo.sh para saber como a chave foi criada        #
#------------------------------------------------------------------------------#
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7erwMfyTSO7xn8axjAp2NTbBHjDVdu+6J17ZjX3Rs55dy3Vsqmq4kBIq3qxShabfY6h5nW3ccc86hGy8coXjPCblyloAKlG0RKkRo7/sGjsl3jv8i0gZVLU/H8pjaLLGhRWca2ToJAPJTlnFk/VrCMvH6PCHca7X70j88uE6UR5W1nax94kzcyOf/65mQDx7dHYVVyBL+Rgn0CHS4Di8Z0PSbwn1dVA0S4JW1z1DZ/5AYdhOBCfPkDvj4trTr9lmJIn/6KnOX+MIMzViHtxZw3dg8VHcZxd2PeiJ/THZZ3Z34Bv60jEwyjZMNKB6fqz4mAGkHH8bAXMS4m6gZXw6TaPZk84x3t9rJnzWhPaUYOkPL9dgcZ8m+FmeUxKkJgdo10AqZAMVdboYEKhL4Uv9JvZrt/VdkM6C2FqIDEddm6TWnqZiteeLtCl0EU5PMxsfQUncHkRihya6R1Brysu5lvTGEvW1qoobONowT3ED2F5aDTPlyscTr4ogKXAJda+jI5oIGxkf2QaKzhdJlt76KktQRVlOQVYJeKcVOB853IVMSJvIpP09YReaibrxdSYeazu+SswqNK7ux7S3Xb82PtSu7jtJtiiCdU6zfCLkWPAmoqP8N3m1q2lw4VvXxvLeUp79n3cv+kabG0UpE2csyJArSX/eyUF7+6F9QWQo4ow== aguia-pescadora-tsuru.no-reply@etica.ai" >> ~/.ssh/authorized_keys

## Reveja as chaves em /root/.ssh/authorized_keys e tenha certeza que esta tudo
## como deveria
sudo cat /root/.ssh/authorized_keys

#------------------------------------------------------------------------------#
# SEÇÃO TSURU: DEPENDENCIAS DO DOCKER MACHINE (É USADO PELO TSURU)             #
#------------------------------------------------------------------------------#
## Resolve o erro do Docker Machine
# Setting Docker configuration on the remote daemon... \n Error running SSH command: ssh command error: \n command : netstat -tln \n err     : exit status 127 \n output  : bash: netstat: command not found
sudo apt install net-tools


#------------------------------------------------------------------------------#
# SEÇÃO NGINX & HTTPS:                                                         #
#------------------------------------------------------------------------------#
# @see https://github.com/EticaAI/aguia-pescadora/issues/15
# @see https://www.digitalocean.com/community/tutorials/como-instalar-o-nginx-no-ubuntu-18-04-pt

# Cancelado. vamos tentar OpenResty


#------------------------------------------------------------------------------#
# SEÇÃO OpenResty & HTTPS:                                                     #
#------------------------------------------------------------------------------#
# @see https://github.com/EticaAI/aguia-pescadora/issues/15
# @see http://openresty.org/en/linux-packages.html

# Nota: em sistemas que já tem NGinx instalado, será necessário o seguinte:
# sudo systemctl disable nginx
# sudo systemctl stop nginx

#### OpenResty, repositório padrão e instalação básica _________________________
### @see http://openresty.org/en/linux-packages.html
# import our GPG key:
wget -qO - https://openresty.org/package/pubkey.gpg | sudo apt-key add -

# for installing the add-apt-repository command
# (you can remove this package and its dependencies later):
sudo apt-get -y install software-properties-common

# add the our official APT repository:
sudo add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main"

# to update the APT index:
sudo apt-get update

# Then you can install a package, say, openresty, like this:
sudo apt-get install openresty

## Acesse o servidor. No caso de bravo, seria estas URLs
# - http://tsuru-dashboard.173.249.10.99.nip.io/
# - http://173.249.10.99/
## E você vera 'Welcome to OpenResty!', pagina padrão.

#### OpenResty + GUI/lua-resty-auto-ssl, instalação básica _____________________
# @see https://github.com/GUI/lua-resty-auto-ssl#installation

# NOTA: sobre instalação do luarocks para o lua-resty-auto-ssl
# Não tenho certeza se a versão que tem no Ubuntu 18.04 do LuaRocks é suficiente
# O link da documentaçãodo Lua Resty Auto SSL manda para documentação padrão
# do OpenResty.org, que diz que instalar o Lua padrão é desaconselhado pois
# o OpenResty ja tem um package manager. Na documentação, falam que existia
# uma versão do lua 2.3.0, mas que usariam a 2.0.13 por questão de
# compatibilidade. Na documetnação do Luarocks eles dizem que a versão estável
# é 3.1.3 (vide https://github.com/luarocks/luarocks/wiki/Download).
#
# No nosso caso aqui, O padrão do Ubuntu 18.04 cita 2.4.2+dfsg-1.
# Vou usar essa padrão do ubuntu e apenas se der problema vou atrás.
# (fititnt, 2019-06-22 21:33 BRT)
sudo apt install luarocks

# Instala o lua-resty-auto-ssl
sudo luarocks install lua-resty-auto-ssl

$ sudo luarocks install lua-resty-auto-ssl

# Create /etc/resty-auto-ssl and make sure it's writable by whichever user your
# nginx workers run as (in this example, "www-data").
sudo mkdir /etc/resty-auto-ssl
sudo chown www-data /etc/resty-auto-ssl

## TODO: rever permissões e usuário do NGinx/OpenResty em breve (fititnt, 2019-06-22 21:40 BRT)

#### OpenResty + GUI/lua-resty-auto-ssl, configuração mínima ___________________
# Edite o arquivo do NGinx para ficar conforme https://github.com/GUI/lua-resty-auto-ssl#installation
# Uma copia deste arquivo está em diario
# de-bordo/delta/usr/local/openresty/nginx/conf/nginx.conf
sudo vim /usr/local/openresty/nginx/conf/nginx.conf

# É preciso criar um certificado padrão para o NGinx pelo menos poder iniciar sem erro
sudo openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
  -subj '/CN=sni-support-required-for-valid-ssl' \
  -keyout /etc/ssl/resty-auto-ssl-fallback.key \
  -out /etc/ssl/resty-auto-ssl-fallback.crt

## root@aguia-pescadora-1:~# sudo openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
## >   -subj '/CN=sni-support-required-for-valid-ssl' \
## >   -keyout /etc/ssl/resty-auto-ssl-fallback.key \
## >   -out /etc/ssl/resty-auto-ssl-fallback.crt
## Can't load /root/.rnd into RNG
## 140384327201216:error:2406F079:random number generator:RAND_load_file:Cannot open file:../crypto/rand/randfile.c:88:Filename=/root/.rnd


# Reinicie o Openresty
sudo systemctl status openresty
sudo systemctl reload openresty

# Para ver erros
tail -f /usr/local/openresty/nginx/logs/error.log

# Erros para tentativa de obter HTTPS para 173.249.10.99.nip.io

## /usr/local/bin/resty-auto-ssl/start_sockproc: line 55: kill: (21760) - No such process
## 2019/06/23 01:50:14 [error] 22053#22053: *16 [lua] lets_encrypt.lua:41: issue_cert(): auto-ssl: dehydrated failed: env HOOK_SECRET=a6e7818677010e3a6addeae5a1b8aaebf65169bd31dd063e88bf3b69cb22b7d5 HOOK_SERVER_PORT=8999 /usr/local/bin/resty-auto-ssl/dehydrated --cron --accept-terms --no-lock --domain 173.249.10.99.nip.io --challenge http-01 --config /etc/resty-auto-ssl/letsencrypt/config --hook /usr/local/bin/resty-auto-ssl/letsencrypt_hooks status: 256 out: # INFO: Using main config file /etc/resty-auto-ssl/letsencrypt/config
## + Generating account key...
## + Registering account key with ACME server...
## Processing 173.249.10.99.nip.io
##  + Signing domains...
##  + Creating new directory /etc/resty-auto-ssl/letsencrypt/certs/173.249.10.99.nip.io ...
##  + Creating chain cache directory /etc/resty-auto-ssl/letsencrypt/chains
##  + Generating private key...
##  + Generating signing request...
##  + Requesting authorization for 173.249.10.99.nip.io...
##  err: Can't load ./.rnd into RNG
## 140690134127040:error:2406F079:random number generator:RAND_load_file:Cannot open file:../crypto/rand/randfile.c:88:Filename=./.rnd
## /usr/local/bin/resty-auto-ssl/dehydrated: line 693: /etc/resty-auto-ssl/letsencrypt/.acme-challenges/gKNgIbdZEGhq9iIhxRK6Hn8xe_kbMJwCKAgVDnxdk3o: Permission denied
## , context: ssl_certificate_by_lua*, client: 201.21.106.135, server: 0.0.0.0:443
## 2019/06/23 01:50:14 [error] 22053#22053: *16 [lua] ssl_certificate.lua:97: issue_cert(): auto-ssl: issuing new certificate failed: dehydrated failure, context: ssl_certificate_by_lua*, client: 201.21.106.135, server: 0.0.0.0:443
## 2019/06/23 01:50:14 [error] 22053#22053: *16 [lua] ssl_certificate.lua:286: auto-ssl: could not get certificate for 173.249.10.99.nip.io - using fallback - failed to get or issue certificate, context: ssl_certificate_by_lua*, client: 201.21.106.135, server: 0.0.0.0:443
## 2019/06/23 01:50:17 [error] 22053#22053: *18 [lua] lets_encrypt.lua:41: issue_cert(): auto-ssl: dehydrated failed: env HOOK_SECRET=a6e7818677010e3a6addeae5a1b8aaebf65169bd31dd063e88bf3b69cb22b7d5 HOOK_SERVER_PORT=8999 /usr/local/bin/resty-auto-ssl/dehydrated --cron --accept-terms --no-lock --domain 173.249.10.99.nip.io --challenge http-01 --config /etc/resty-auto-ssl/letsencrypt/config --hook /usr/local/bin/resty-auto-ssl/letsencrypt_hooks status: 256 out: # INFO: Using main config file /etc/resty-auto-ssl/letsencrypt/config
