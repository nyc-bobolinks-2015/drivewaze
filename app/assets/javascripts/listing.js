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
    var latLong = window.map.getBounds()
    var westBound = latLong.j.j
    var eastBound = latLong.j.O
    var northBound = latLong.O.j
    var southBound = latLong.O.O

    $.ajax({
      method: 'get',
      url: '/search' + "?westBound=" + westBound + "&eastBound=" + eastBound + "&northBound=" + northBound + "&southBound=" + southBound
    }).done(function(response){
      for(var i = 0; i < response.length; i++) {
        var marker = new google.maps.Marker({
            map: window.map,
            position: {lat: response[i].latitude, lng: response[i].longitude},
            title: ("$" + String(response[0].hourly_price) + '.00'),
            label: "$",
            id: response[i].id
        });
          marker.addListener('click', function(event){
            $.ajax({
              method: 'get',
              url: '/listings/' + this.id
            }).done(function(response){
              $(".single-listing").html(response);
            })

          });

      }
    }).fail(function(error){
      console.log(error)
    })
  })

  $("#search-form").on('submit', function(event){
    event.preventDefault();

    $.ajax({
      method: 'post',
      url: $(event.target).attr('action'),
      data: $(event.target).serialize(),
      dataType: 'json'
    }).done(function(response){
      var newLatLong = new google.maps.LatLng(response.results[0]["geometry"]["location"]["lat"], response.results[0]["geometry"]["location"]["lng"])
      window.map.setCenter(newLatLong)
    }).fail(function(error){
      console.log(error);
    });
  })

});
