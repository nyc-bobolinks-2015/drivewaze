var ready=function(){
	var id = $('#parkingSpotMenuContainer').attr('data-id');
	var slotType=$('#propertyTypeMenu').attr('data-type');
	$('#propertyTypeMenu button:nth-child('+(slotType+1)+')').addClass('selected'); //?
	// $('#propertyType').on('click',function(event){
	// 	$('#parkingSpotMenuContainer').hide();
	// 	$.ajax({
	// 		method:"get",
	// 		url:"/parking_slots/"+id+"/edit",
	// 		data:"request=property_type"
	// 	}).done(function(result){
	// 		$("#ajaxParkingSpotMenuContainer").append(result);
	// 	}).fail(function(error){
	// 		console.log(error);
	// 	});
		// $('body').append(result);
	// });

		// elseif(($(event.target).attr("id"))==="price"){
		// 	console.log("price");
		// }elseif($(event.target).attr("id")==="schedule"){
		// 	console.log("schedule");
		// }elseif($(event.target).attr("id")==="vehicleClass"){
		// 	console.log("vehicleClass");
		// };

};

function selectProperty(propertyType){
	var id = $('#parkingSpotMenuContainer').attr('data-id');
	$.ajax({
		
	})
}

$(document).ready(ready);
$(document).on('page:load',ready);
