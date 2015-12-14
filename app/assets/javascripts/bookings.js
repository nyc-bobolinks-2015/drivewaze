$(document).ready(function(){
	console.log("hello hhh");	
});


function showCalendar(source){
	$("#listingShow").hide();
	$("#availabilityFilter").removeClass("hide");
	$('#date-cal-div').fullCalendar({
		header:{
			left:'prev,next today',
			center:'title',
			right:'month'
		},
		selectable:true,
		selectHelper:true,
		select:function(start,end,jsEvent,view){
			// $('#startTime').text(moment(start).format('MMMM D, YYYY'));
			// $('#endTime').text(moment(end).format('MMMM D, YYYY'));
			if($('#date-cal-div').attr('data-type')=="arrival"){
				$('#arrivalDate').text(moment(start).format('MMMM D YYYY'));
				// console.log($(jsEvent.target).index());
				var index=$(jsEvent.target).index()+1;
				// console.log($(jsEvent.target).closest("div").siblings(".fc-bg:first").find("td:nth-child("+index+")").css("background-color","black"));
			}else{
				$('#departureDate').text(moment(start).format('MMMM D YYYY'));
			}
		}
	});
}

function selectDepartureDate(){
	// $('#date-cal-div').toggle(".hide")
	$('#date-cal-div').attr('data-type',"departure");
}

function submitFilter(){
	var listingId=$("#listingShow").attr("data-id");
	var vehicleClass=$("#vehicleClassSelect").val();
	var startDate=$('#arrivalDate').text();
	var departDate=$('#departureDate').text();
	$.ajax({
		method:"get",
		url:"/listings/"+listingId+"/availability",
		data:"vehicle_class="+vehicleClass+"&start_date="+startDate+"&depart_date="+departDate
	}).done(function(result){
		if(result.status=="success"){
			window.location.href="/parking_slots/"+result.redirect+"/parking_slots_time_slots/new?new_booking=true";
			// console.log(result.redirect);
			// console.log(result);
		}else{
			swal({
		    title: "Unavailable!",
		    text: "Our apologies, there is no availabitlity for this listing during the time you have selected.",
		    showConfirmButton: false,
		    allowOutsideClick: true,
		    timer: 2600,
		    type: "error",
		  });
		}
	}).fail(function(error){
			swal({
		    title: "Server Error!",
		    text: "Our apologies! Our service is currently Unavailable.",
		    showConfirmButton: false,
		    allowOutsideClick: true,
		    timer: 2000,
		    type: "error",
		  });
		  console.log(error);
	});
}
