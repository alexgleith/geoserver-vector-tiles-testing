# geoserver-vector-tiles-testing
A test of the use of vector tiles in GeoServer with MapBoxGL

# Run
`make run`

This will run GeoServer and a small MapboxGL website, in dev mode, in Docker.

# Get sample data
`get-data`

This will download a dataset (cadastre for Hobart) and put it in the right place. You still need to manually add it to GeoServer (todo)

# What do I do now it's running?

Got to http://localhost to view the map or go to http://localhost:8080 to get to GeoServer. Use the username/password 'admin/geoserver' to get in.
