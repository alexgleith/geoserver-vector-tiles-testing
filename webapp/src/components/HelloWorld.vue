<template>
  <div>
    <nav id="menu"></nav>
    <div id="map"></div>
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
    var layerMBTiles = 'http://127.0.0.1:5000/list_parcels_hobart/{z}/{x}/{y}'
   
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

      // Geoserver layer
      map.addLayer({
        'id': 'geoserver',
        'type': 'fill',
        'source': {
          'type': 'vector',
          'tiles': [
            layerWMTS
          ]
        },
        'layout': {
          'visibility': 'none'
        },
        'source-layer': 'list_parcels_hobart_4326',
        'paint': {
          'fill-color': 'rgba(244, 131, 66, 0.4)',
          'fill-outline-color': 'rgba(244, 131, 66, 0.9)'
        }
      }, firstSymbolId)

      // MBTiles layer
      map.addLayer({
        'id': 'mbtiles',
        'type': 'fill',
        'source': {
          'type': 'vector',
          'tiles': [
            layerMBTiles
          ]
        },
        'layout': {
          'visibility': 'visible'
        },
        'source-layer': 'list_parcels_hobart',
        'paint': {
          'fill-color': 'rgba(66, 101, 244, 0.4)',
          'fill-outline-color': 'rgba(66, 101, 244, 0.9)'
        }
      }, firstSymbolId)
    })

    map.on('click', 'geoserver', function (e) {
      if (e.features.length > 0) {
        new mapboxgl.Popup()
          .setLngLat(e.lngLat)
          .setHTML('<p>PID: ' + e.features[0].properties.PID + '</p>')
          .addTo(map)
      }
    })

    map.on('click', 'mbtiles', function (e) {
      if (e.features.length > 0) {
        new mapboxgl.Popup()
          .setLngLat(e.lngLat)
          .setHTML('<p>PID: ' + e.features[0].properties.PID + '</p>')
          .addTo(map)
      }
    })

    var toggleableLayerIds = [ 'geoserver', 'mbtiles' ]

    for (var i = 0; i < toggleableLayerIds.length; i++) {
      var id = toggleableLayerIds[i]

      var link = document.createElement('a')
      link.href = '#'
      link.className = 'active'
      if (i === 0) {
        link.className = ''
      }
      link.textContent = id

      link.onclick = function (e) {
        var clickedLayer = this.textContent
        e.preventDefault()
        e.stopPropagation()

        var visibility = map.getLayoutProperty(clickedLayer, 'visibility')

        if (visibility === 'visible') {
          map.setLayoutProperty(clickedLayer, 'visibility', 'none')
          this.className = ''
        } else {
          this.className = 'active'
          map.setLayoutProperty(clickedLayer, 'visibility', 'visible')
        }
      }

      var layers = document.getElementById('menu')
      layers.appendChild(link)
    }
  }
}
</script>
<style>
#menu {
    background: #fff;
    position: absolute;
    z-index: 1;
    top: 10px;
    right: 10px;
    border-radius: 3px;
    width: 120px;
    border: 1px solid rgba(0,0,0,0.4);
    font-family: 'Open Sans', sans-serif;
}

#menu a {
    font-size: 13px;
    color: #404040;
    display: block;
    margin: 0;
    padding: 0;
    padding: 10px;
    text-decoration: none;
    border-bottom: 1px solid rgba(0,0,0,0.25);
    text-align: center;
}

#menu a:last-child {
    border: none;
}

#menu a:hover {
    background-color: #f8f8f8;
    color: #404040;
}

#menu a.active {
    background-color: #3887be;
    color: #ffffff;
}

#menu a.active:hover {
    background: #3074a4;
}
</style>
