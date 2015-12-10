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

  $('#map').on('click', function(event){
    event.preventDefault();
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
  })
});
