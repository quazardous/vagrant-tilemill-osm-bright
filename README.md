# Vagrant - Tilemill OSM-Bright Template

A preconfigured Vagrant box running Ubuntu 14.04, Tilemill and PostgreSQL/Postgis.
Tilemill will be accesible via Browser on http://localhost:20009.

## Get Started:

- install Vagrant and Virtualbox
- clone this repository
- copy `Vagrantfile.example` to `Vagrantfile`
- run `vagrant up` on your local machine inside the repository
- wait for vagrant to complete downloading the Ubuntu base box and installing the software
- log into the VM by running `vagrant ssh`

*NB*: you'll need to proceed with the next step.

## Download OSM Data and Import to PostgreSQL:

Inside the VM you can run the `load-osm-data.sh` script to download OSM
data and import it to PostgreSQL. It will also setup OSM Bright.

When running the script, you can attach the download address of an OSM Planet file:

```bash
./load-osm-data.sh https://s3.amazonaws.com/metro-extracts.mapzen.com/leipzig_germany.osm.pbf
```

or put them in the `osm` folder.

*NB*: `imposm` could ask you a password, just type what you want.

Example Download Sources:

- https://mapzen.com/data/metro-extracts
- http://download.geofabrik.de/

Depending on the size of the planet file, the download/import will take
some time.

## Get Re-started

If you reboot your box you'll need to restart some services:

From host:

    vagrant ssh

Then in the VM:

    sudo service postgresql start
    sudo start tilemill

