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
			data_dir/data/shapefiles/list_parcels_hobart_4326.shp ./tmp/list_parcels_hobart.shp

convert-data:
	ogr2ogr -f "GeoJSON" -overwrite -t_srs "EPSG:4326" \
			mbtiles/list_parcels_hobart.json ./tmp/list_parcels_hobart.shp

make-mbtiles:
	docker run --rm -v $(shell pwd)/mbtiles:/data alexgleith/tippecanoe \
		tippecanoe -o /data/list_parcels_hobart.mbtiles \
			--force \
			--maximum-zoom=16 \
			--coalesce \
			--detect-shared-borders \
			--maximum-tile-bytes=1000000 \
			--no-feature-limit \
			--simplification=10 \
			-x POT_PID -x COMP_AREA -x MEAS_AREA -x UFI -x FMP -x CREATED_ON -x LIST_GUID -x SHAPE_AREA -x SHAPE_LEN \
			-l list_parcels_hobart -n "Properties in Hobart" /data/list_parcels_hobart.json

mbtiles-bash:
	docker run -it -v $(shell pwd)/mbtiles:/data alexgleith/tippecanoe \
		bash
