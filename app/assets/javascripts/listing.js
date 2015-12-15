function initMap() {
  window.map = new google.maps.Map(document.getElementById('map'),
   {
    center: {lat: 40.7060137, lng: -74.0110914},
    scrollwheel: false,
    zoom: 14
    });

  var input = (document.getElementById('term'));

  new google.maps.places.Autocomplete(input);
  var searchBox = new google.maps.places.SearchBox(input);
  searchBox.addListener('places_changed', function(event) {
    var places = searchBox.getPlaces();
    var place = {term: places[0].formatted_address}
     $.ajax({
        method: 'post',
        url: '/search',
        data: $.param(place),
        dataType: 'json'
      }).done(function(response){
        var newLatLong = new google.maps.LatLng(response.results[0]["geometry"]["location"]["lat"], response.results[0]["geometry"]["location"]["lng"])
        window.map.setCenter(newLatLong)
        window.map.setZoom(14);
      }).fail(function(error){
        console.log(error);
    });
  })
  // autocomplete.addListener('place_changed', function() {
  //   var place = autocomplete.getPlace();
  //   window.map.setCenter(place)
  // })
}

//----------------
var ready=function(){

    $("#newListingForm").on("submit",function(event){
    event.preventDefault();
    var listingAddress = $("#listingAddress").val();
    $("#listing_address").val(listingAddress);
    $("#listingPageAddress").hide();
    $("#listingPageInfo").removeClass('hide');
    $('#static-map').children()[0].src = "https://maps.googleapis.com/maps/api/staticmap?center=" + listingAddress + "&zoom=15&size=1000x1000&maptype=roadmap&markers=" + listingAddress + "&key=#{ENV['GMAP_STATIC_KEY']}"
  });


  if ($('#map').length) {

  initMap();
  (function(){

    $.ajax({
      method: 'get',
      url: '/listings'
      }).done(function(response) {
        for(var i = 0; i < response.length; i++) {
          var marker = new google.maps.Marker({
            map: window.map,
            position: {lat: response[i].latitude, lng: response[i].longitude},
            title: String(response[0].address)
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
      url: '/search' +
           "?westBound=" + westBound +
           "&eastBound=" + eastBound +
           "&northBound=" + northBound +
           "&southBound=" + southBound
      }).done(function(response){
          for(var i = 0; i < response.length; i++) {
            var marker = new google.maps.Marker({
              map: window.map,
              position: {lat: response[i].latitude, lng: response[i].longitude},
              title: String(response[0].address),
              id: response[i].id
            });
            marker.addListener('click', function(event){
              $.ajax({
                method: 'get',
                url: '/listings/' + this.id
              }).done(function(response){
                window.map.setCenter(marker.position)
                $(".single-listing").html(response);
               })
            });
           }
        }).fail(function(error){
          console.log(error)
          })
  })

  $("#search_term").on('submit', function(event){
    event.preventDefault();
  });

  $('.single-listing').on('click', '.listing-info', function(event) {
    window.location.href = '/listings/' + this.id;
  });
<<<<<<< HEAD

}
};

$(document).ready(ready);
$(document).on('page:load',ready);
=======
});
>>>>>>> commit before redo
