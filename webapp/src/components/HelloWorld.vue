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
    var map = new mapboxgl.Map({
      container: 'map', // container id
      style: 'mapbox://styles/mapbox/streets-v9', // stylesheet location
      center: [-74.50, 40], // starting position [lng, lat]
      zoom: 9 // starting zoom
    })
    console.log(map)
  }
}
</script>
