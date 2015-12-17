function showBlackoutCal(offset){
	$("#ajaxParkingSpotMenuContainer").removeClass("hide");
	$("#ajaxParkingSpotMenuContainer").show();
	var parkingSlotId=$('#parkingSpotMenuContainer').attr('data-id');
	$.ajax({
		method:"get",
		url:"/parking_slots/"+parkingSlotId+"/calendar?offset="+offset
	}).done(function(result){
		$("#calendarTable").html(result);

		$(".future, .blackout").on("click",function(event){
			var dateSelected=$(event.target).attr("data-day");
			$.ajax({
				method:"post",
				url:"/parking_slots/"+parkingSlotId+"/time_slots",
				data:"time="+dateSelected
			}).done(function(result){
				if(result.status=="success"){
					$(event.target).css("background-color","pink");
				}else{
					// $(event.target).removeClass().addClass(result.status);
					if(result.status=="present"){
						$(event.target).css("background-color","#5FDC9E");
					}else if(result.status=="this-month future"){
						$(event.target).css("background-color","white");
					}else{
						$(event.target).css("background-color","#80FB6C")
					}
				}
			}).fail(function(error){
				console.log(error);
				swal({
			    title: "Error!",
			    text: error,
			    showConfirmButton: false,
			    allowOutsideClick: true,
			    timer: 1500,
			    type: "error"
			  });
			});
		});

	}).fail(function(error){
		console.log(error);
	});
}

function moveCalendar(direction){
	var calendarOffset=parseInt($("#calendarTable").attr("data-offset"));
	if(direction=="forward"){
		if(parseInt(calendarOffset)<3){
			calendarOffset=calendarOffset+1;
			$("#calendarTable").attr("data-offset",calendarOffset);
			showBlackoutCal(calendarOffset);
		}
	}else{
		if(parseInt(calendarOffset)>0){
			calendarOffset=calendarOffset-1;
			$("#calendarTable").attr("data-offset",calendarOffset);
			showBlackoutCal(calendarOffset);
		}
	}
}


function closeCalendar(){
	$("#ajaxParkingSpotMenuContainer").hide();
}