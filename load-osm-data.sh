#! /bin/sh

# load-osm-data.sh
#
# Download OSM data and import to local postgresql database
#
# Usage: ./load-osm-data.sh [<URL to [regional] planetfile.osm.pbf>]
#


if [ ! -z "$1" ]
then
(
	cd /vagrant
	mkdir -p osm
	cd osm
	echo '### Downloading OSM Planetfile...'
	wget $1
)
fi

if [ ! -d /home/vagrant/osm/osm-bright ]
then
(
	mkdir -p /home/vagrant/osm
	cd /home/vagrant/osm
	echo '### Cloning osm-bright GitHub Repoistory...'
	git clone https://github.com/mapbox/osm-bright.git

	echo '### Create OSM Bright Tilemill Project'
	cp /vagrant/config/osm-bright-configure.py /home/vagrant/osm/osm-bright/configure.py
	cd /home/vagrant/osm/osm-bright
	sudo ./make.py
	sudo chown -R vagrant:vagrant /home/vagrant/osm/osm-bright
)
fi
	
(
	# imposm needs unix fs (?)
	cd
	
echo '### Importing OSM data...'
find /vagrant/osm/ -name '*.osm.pbf' | while read f
do
	if [ -f $f.ok ]
	then
		continue
	fi
	if imposm -U vagrant -d osm -m /home/vagrant/osm/osm-bright/imposm-mapping.py \
		--read --write --optimize --deploy-production-tables $f
	then
		touch $f.ok
	fi
done
)

if [ ! -d /usr/share/mapbox/project/OSMBright/shp ]
then
(
	echo '### Downloading OSM land polygons...'
	sudo mkdir -p /usr/share/mapbox/project/OSMBright/shp
	cd /usr/share/mapbox/project/OSMBright/shp
	sudo wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip
	sudo unzip simplified-land-polygons-complete-3857.zip
	sudo wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip
	sudo unzip land-polygons-split-3857.zip
	sudo chown -R mapbox:mapbox /usr/share/mapbox/project/OSMBright/
)
fi

