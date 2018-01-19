run:
	docker-compose up

build:
	docker-compose build

clean:
	-rm -rf webapp/node_modules

node-cmd:
	docker-compose run node bash

get-data: download-data load-data

download-data:
	-mkdir -p data_dir/data/shapefiles
	-mkdir tmp
	wget https://listdata.thelist.tas.gov.au/opendata/data/LIST_PARCELS_HOBART.zip -O tmp/LIST_PARCELS_HOBART.zip

load-data:
	unzip -o tmp/LIST_PARCELS_HOBART.zip -d tmp \
		&& ogr2ogr -f "ESRI Shapefile" -overwrite -t_srs "EPSG:4326" \
			data_dir/data/shapefiles/list_parcels_hobart_4326.shp ./tmp/list_parcels_hobart.shp \
		&& rm -rf tmp/list_parcels_hobart*
