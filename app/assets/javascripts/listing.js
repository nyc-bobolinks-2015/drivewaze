function initMap() {
  // Create a map object and specify the DOM element for display.
  window.map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 40.7060137, lng: -74.0110914},
    scrollwheel: false,
    zoom: 8
  });
}

$(document).ready(function(){
  initMap();

 (function(){

    $.ajax({
      method: 'get',
      url: '/listings'
    }).done(function(response){
      for(var i = 0; i < response.length; i++) {
        var marker = new google.maps.Marker({
            map: window.map,
            position: {lat: response[i].latitude, lng: response[i].longitude},
            title: ("$" + String(response[0].hourly_price) + '.00')
  });
      }
    }).fail(function(error){
      console.log(error)
    })
  })();

  window.map.addListener('bounds_changed', function(event){

    latLong = window.map.getBounds()
    westBound = latLong.j.j
    eastBound = latLong.j.O
    northBound = latLong.O.j
    southBound = latLong.O.O

    $.ajax({
      method: 'get',
      url: '/search' + "?westBound=" + westBound + "&eastBound=" + eastBound + "&northBound=" + northBound + "&southBound=" + southBound
    }).done(function(response){
      var markers = []
      for(var i = 0; i < response.length; i++) {
        var marker = new google.maps.Marker({
            map: window.map,
            position: {lat: response[i].latitude, lng: response[i].longitude},
            title: ("$" + String(response[0].hourly_price) + '.00'),
            label: "$"
        });


      }
    }).fail(function(error){
      console.log(error)
    })
  })

});
