<template>
  <div id="map">
  </div>
</template>

<script>
import mapboxgl from 'mapbox-gl'
export default {
  name: 'HelloWorld',
  mounted () {
    mapboxgl.accessToken = 'pk.eyJ1IjoiYWxleGdsZWl0aCIsImEiOiIwZU0xU2RZIn0.z4BFqvJIf6fnzlIGQUmptQ'
    var startCenter = [147.31, -42.89]
    var startZoom = 13
    var layerWMTS = 'http://localhost:8080/geoserver/gwc/service/wmts?layer=public:list_parcels_hobart_4326&tilematrixset=EPSG:900913&Service=WMTS&Request=GetTile&Version=1.0.0&Format=application/x-protobuf;type=mapbox-vector&TileMatrix=EPSG:900913:{z}&TileCol={x}&TileRow={y}'
    var map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v9',
      center: startCenter,
      zoom: startZoom,
      minZoom: 11
    })

    map.on('load', function () {
      var layers = map.getStyle().layers
      var firstSymbolId
      for (var i = 0; i < layers.length; i++) {
        if (layers[i].type === 'symbol') {
          firstSymbolId = layers[i].id
          break
        }
      }

      map.addLayer({
        'id': 'test-layer',
        'type': 'fill',
        'source': {
          'type': 'vector',
          'tiles': [
            layerWMTS
          ]
        },
        'source-layer': 'list_parcels_hobart_4326',
        'paint': {
          'fill-color': 'rgba(244, 131, 66, 0.4)',
          'fill-outline-color': 'rgba(244, 131, 66, 0.9)'
        }
      }, firstSymbolId)
    })
    map.on('click', 'test-layer', function (e) {
      if (e.features.length > 0) {
        new mapboxgl.Popup()
          .setLngLat(e.lngLat)
          .setHTML('<p>PID: ' + e.features[0].properties.PID + '</p>')
          .addTo(map)
      }
    })
  }
}
</script>
