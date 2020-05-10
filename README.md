Kalem : Self-hosted multi websites generator (prestashop...) with reverse proxy and dynamic TLS certificate
===========================================================================================================

*Kalem* is an open source project, composed of multiple scripts, that eases and helps to setup multiple websites (such as prestashop) on a single hosted server.
Kalem will generate/renew the SSL certificate automatically from [lets_encrypt](https://letsencrypt.org) Certificate Authority whenever you create a new website.
Kalem is fully based on bash and docker.

How To
======
* First, configure the DNS of your domain name to have an A record pointing to your server's IP
* Clone this repository in your server /var/www folder (this is important)
* install the reverse proxy by executing `./install_reverse_proxy.sh`
* install your website (for that domain) by executing `./install_website.sh` (all steps are displayed in the output when executing this script)

Supported Websites type
=======================
For now, [Prestashop](https://build.prestashop.com/news/prestashop-and-docker/) is supported.
The idea is to extend Kalem to support easy Wordpress, Drupal, Magento... setup.

Backup Policy
=============
Prestashop
----------
You can easily backup your pretashop instance so whenever your server crashes, you can minimize the data lost.
To do so, 2 volumes are created for prestashop (one for database, the other for prestashop). These volumes are generated under website `volumes`'s folder.
It is up to you to create a backup policy that will match your requirements (for instance 1 backup a day).

Courtesy
========
This project is highly inspired from [François Romain](https://medium.com/@francoisromain/) article : [Host multiple websites with HTTPS on a single server](https://medium.com/@francoisromain/host-multiple-websites-with-https-inside-docker-containers-on-a-single-server-18467484ab95).
I customized his project and add a layer of automation through scripts, to minimize manual setup.

License
=======
Kalem is under MIT License.