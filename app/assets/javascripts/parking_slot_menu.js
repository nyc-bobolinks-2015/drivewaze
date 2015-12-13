var ready=function(){

	var id = $('#parkingSpotMenuContainer').attr('data-id');
	var currentSlotType=$('#propertyTypeMenu').attr('data-type');
	var currentVehicleClass=$('#vehicleClassMenu').attr('data-type');
	currentSlotType=parseInt(currentSlotType)+1;
	currentVehicleClass=parseInt(currentVehicleClass)+1;
	if(currentSlotType>-1){
		$('#propertyTypeMenu button:nth-child('+currentSlotType+')').addClass('selected');
	}
	if(currentVehicleClass>-1){
	$('#vehicleClassMenu button:nth-child('+currentVehicleClass+')').addClass('selected');
	}
};

function capitalize(string){
	return string.charAt(0).toUpperCase() + string.slice(1);
}

var errorSwal=function(source){
	return swal({
    title: "Error!",
    text: source,
    showConfirmButton: false,
    allowOutsideClick: true,
    timer: 1500,
    type: "error"
  });
};
var successSwal=function(source){
	return swal({
    title: "Success!",
    text: source,
    showConfirmButton: false,
    allowOutsideClick: true,
    timer: 1500,
    type: "success",
  });
};
// var id = $('#parkingSpotMenuContainer').attr('data-id');
function selectProperty(propertyType){
	var id = $('#parkingSpotMenuContainer').attr('data-id');
	$.ajax({
		method:"put",
		url:"/parking_slots/"+id,
		data:"slot_type="+propertyType+"&id="+id
	}).done(function(result){
		if(result.status==="success"){
			$("#propertyTypeMenu button").removeClass("selected");
			$("#propertyTypeMenu button:nth-child("+(propertyType+1)+")").addClass("selected");
			successSwal("property type saved successfully");
		}else{
			errorSwal(result.error);
		}
	}).fail(function(error){
		errorSwal(error);
	});
}

function selectVehicleClass(vehicleClass){
	var id = $('#parkingSpotMenuContainer').attr('data-id');
	$.ajax({
		method:"put",
		url:"/parking_slots/"+id,
		data:"vehicle_class="+vehicleClass+"&id="+id
	}).done(function(result){
		if(result.status==="success"){
			$("#vehicleClassMenu button").removeClass("selected");
			$("#vehicleClassMenu button:nth-child("+(vehicleClass+1)+")").addClass("selected");
			successSwal("vehicle class saved successfully");
		}else{
			console.log(result.error);
			errorSwal(result.error);
		}
	}).fail(function(error){
		console.log(error);
		errorSwal(error);
	});
}

function setPrice(priceType){
	var timeFrame;
	if(priceType===0){
		timeFrame="hourly";
	}else if(priceType===1){
		timeFrame="daily";
	}else if(priceType===2){
		timeFrame="weekly";
	}else{
		timeFrame="monthly";
	}
	console.log(priceType);
	swal({
		title:"Set "+capitalize(timeFrame)+" Rate",
		text:"Please enter number only:",
		type:"input",
		showCancelButton:true,
		closeOnConfirm:false,
		animation:"slide-from-top",
		inputPlaceholder:"2.5",
		showLoaderOnConfirm:true
	},
	function(inputValue){
		var id = $('#parkingSpotMenuContainer').attr('data-id');
		console.log(inputValue);
		if(inputValue===false) return false;
		if(inputValue===""){
			swal.showInputError("Please set "+timeFrame+" rate for your parking slot.");
			return false;
		}else if(!$.isNumeric(inputValue)){
			swal.showInputError("Please enter numbers only");
			return false;
		}
		$.ajax({
			method:"put",
			url:"/parking_slots/"+id,
			data:timeFrame+"_price="+inputValue+"&id="+id
		}).done(function(result){
			swal({
				title:"Success!",
				text:timeFrame+" price saved successfully",
				type:"success",
				timer:1500,
				allowOutsideClick:true,
				showConfirmButton:false
			});
		}).fail(function(error){
			swal({
				title:"Error!",
				text:"Apologies, our service is currently unavailable",
				type:"error",
				timer:1500,
				allowOutsideClick:true,
				showConfirmButton:false
			});
		});
	});
}
$(document).ready(ready);
$(document).on('page:load',ready);
