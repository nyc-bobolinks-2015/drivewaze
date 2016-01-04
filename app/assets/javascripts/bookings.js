function displayCalendar(psindex){
	$("#date-cal-div").removeClass("hide");

	var vehicleClass=$("#vehicleClassSelect").val();
	var listingId=$('#listingShow').attr('data-id');
	var offset=$("#bookingCalendarTable").attr("data-offset");
	$.ajax({
		method:"get",
		url:"/listings/"+listingId+"/availability",
		data:"vehicle_class="+vehicleClass+"&offset="+offset+"&psindex="+psindex
	}).done(function(result){
		if(result.status=="Unavailable"){
			swal({
		    title: "Unavailable!",
		    text: "This listing is unavailable",
		    showConfirmButton: false,
		    allowOutsideClick: true,
		    timer: 2500,
		    type: "info"
		  });
		}else{
			$('#bookingCalendarTable').html(result);
			var parking_slot_id=$("#pstotal").attr("data-psid");
			$.ajax({
				method:"get",
				url:"/listings/"+listingId+"/total"
			}).done(function(result){
				$("#totalDisplay").text(result.total);
			}).done(function(error){
				console.log(error);
			});
		}

		$(".future, .selectedDate").on("click",function(event){
			var dateSelected=$(event.target).attr("data-day");
			var parking_slot_id=$("#pstotal").attr("data-psid");
			$.ajax({
				method:"post",
				url:"/listings/"+listingId+"/bookings",
				data:"time="+dateSelected+"&psid="+parking_slot_id
			}).done(function(result){
				if(result.status=="success"){
					$(event.target).css("background-color","yellow");
					$("#totalDisplay").text(result.total);
				}else{
					// $(event.target).removeClass().addClass(result.status);
					if(result.status=="present"){
						$(event.target).css("background-color","#5FDC9E");
					}else if(result.status=="this-month future"){
						$(event.target).css("background-color","white");
					}else{
						$(event.target).css("background-color","#80FB6C")
					}
					$("#totalDisplay").text(result.total);
				}
			}).fail(function(error){
				console.log(error);
			});
		});

	}).fail(function(error){
		console.log(error);
	});
}

function changePsindex(direction){
	var psindex=parseInt($("#bookingCalendarTable").attr("data-psindex"));
	var totalps=parseInt($("#pstotal").attr("data-pstotal"));

	if(direction=="forward"){
		if(psindex<(totalps-1)){
			psindex=psindex+1;
			$("#bookingCalendarTable").attr("data-offset",0);
			$("#bookingCalendarTable").attr("data-psindex",psindex);
			displayCalendar(psindex);
		}
	}else{
		if(psindex>0){
			psindex=psindex-1;
			$("#bookingCalendarTable").attr("data-offset",0);
			$("#bookingCalendarTable").attr("data-psindex",psindex);
			displayCalendar(psindex);
		}
	}
}

function moveBookingCalendar(direction){
	var calendarOffset=parseInt($("#bookingCalendarTable").attr("data-offset"));
	var psindex=parseInt($("#bookingCalendarTable").attr("data-psindex"));
	if(direction=="forward"){
		if(parseInt(calendarOffset)<3){
			calendarOffset=calendarOffset+1;
			$("#bookingCalendarTable").attr("data-offset",calendarOffset);
			// showBlackoutCal(calendarOffset);
			displayCalendar(psindex);
		}
	}else{
		if(parseInt(calendarOffset)>0){
			calendarOffset=calendarOffset-1;
			$("#bookingCalendarTable").attr("data-offset",calendarOffset);
			// showBlackoutCal(calendarOffset);
			displayCalendar(psindex);
		}
	}
}

function showCalendar(){
	$("#listingShow").hide();
	$("#availabilityFilter").removeClass("hide");
}

function confirmBooking(){
	listingId=$('#listingShow').attr('data-id');
	$.ajax({
		method:"get",
		url:"/listings/"+listingId+"/bookings/confirmation?check=true"
	}).done(function(result){
		if(result.status="success"){
			window.location.href="/listings/"+listingId+"/bookings/confirmation";
		}else{
			swal({
		    title: "No Selected Time!",
		    text: "Our apologies, we are unable to find the time you have selected. Please use the calendar to select desirable rental periods.",
		    showConfirmButton: false,
		    allowOutsideClick: true,
		    timer: 2000,
		    type: "info"
		  });
		}
	}).fail(function(error){
		console.log(error);
	});
}
