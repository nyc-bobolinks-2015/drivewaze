var ready=function(){
	// var startTime="default";
	// var endTime="default";
	var parkingSlotId=$("#cal-div").attr("data-id");
	$('#cal-div').fullCalendar({
		height:800,
		contentHeight:700,
		header:{
			left:'prev,next today',
			center:'title',
			right:'month,agendaWeek,agendaDay'
		},
		slotLabelInterval:'02:00:00',
		selectable:true,
		selectHelper:true,
		slotDuration:'02:00:00',
		eventLimit:true,
		// snapDuration:'02:00:00',
		select:function(start,end,jsEvent,view){
			$('#startTime').text(moment(start).format('h:mm a - MMMM D, YYYY'));
			$('#endTime').text(moment(end).format('h:mm a - MMMM D, YYYY'));
			$('#hiddenStartTime').text(moment(start).format('MMMM D YYYY h:mm:ss a'));
			$('#hiddenEndTime').text(moment(end).format('MMMM D YYYY h:mm:ss a'));
			$('#newEvent').modal({show:true});
			// console.log(moment(end).format('MMMM D, YYYY'));
		},
		events:{
			type:"get",
			url:"/api/parking_slots/"+parkingSlotId+"/parking_slots_time_slots",
			data:function(){
			  var view = $('#cal-div').fullCalendar('getView');
			  var endDate = moment(view.end._d).format('MMMM D YYYY h:mm:ss');
			  var startDate = moment(view.start._d).format('MMMM D YYYY h:mm:ss');
				return {start:startDate, end:endDate};
			}
		},
	});

	$("#blackOutTimeSlotButton").on("click",function(event){
		event.preventDefault();
		// console.log("start_time="+$('#hiddenStartTime').text()+"&end_time="+$('#hiddenEndTime').text()+"&parking_slot_id="+parkingSlotId);
		$("#newEvent").modal('toggle');
		$.ajax({
			method:"post",
			url:"/parking_slots/"+parkingSlotId+"/parking_slots_time_slots",
			data:"start_time="+$('#hiddenStartTime').text()+"&end_time="+$('#hiddenEndTime').text()+"&parking_slot_id="+parkingSlotId
		}).done(function(result){
			console.log(result);
			console.log("here");
			$("#cal-div").fullCalendar('refetchEvents');
		}).fail(function(error){
			console.log(error);
		});
	});




};
$(document).ready(ready);
$(document).on('page:load',ready);