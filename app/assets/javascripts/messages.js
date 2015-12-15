var myDataref = new Firebase('https://drivewaze.firebaseio.com/');

document.addEventListener('DOMContentLoaded', function(){

  $(".new-message-container").on("submit", "#form", function(event){
  event.preventDefault();
    var fromUser = document.getElementById('fromUser').value;
    var toUser = document.getElementById('toUser').value;
    var messageObj = {
          sent_at: String(new Date()),
          fromUser: fromUser,
          toUser:  toUser,
          message: document.getElementById('msgText').value,
          bookingID: document.getElementById("booking_id").value
        };

    var dest = 'msgs/' + [fromUser.toLowerCase(), toUser.toLowerCase()].sort().join('-');

    var node  = myDataref.child(dest);
    node.push(messageObj);

    var clearField = $("#msgText")
    clearField.val("");

  });

if($('#toUser').length) {
    var currentUser = $("#fromUser").val();
    var provider = $('#toUser').val();
    var myNode = 'msgs/' + [currentUser.toLowerCase(), provider.toLowerCase()].sort().join('-');
    myDataref.child(myNode).on("value", function(snapshot) {
      var element = document.getElementById('messages');
      var output = '';
      snapshot.forEach(function(child){
        var msg = child.val();
        output += ("From: " + msg.fromUser + " To: " + msg.toUser + "<br>" + msg.message + "<br>" + msg.sent_at +
          "<br>");
      });
      element.innerHTML = output;
    });
}

if ($('#all-messages').length) {
  console.log('hello')
    var currentUser = $("#current_user_nav").text();
    var specificNode = 'msgs' //currentUser.toLowerCase() +
    // debugger;
    myDataref.child(specificNode).on("value", function(snapshot) {
      var convs = [];
      snapshot.forEach(function(child){
        var key = child.key();
        var conv = { people: key };
        conv.messages = [];
        if(key.indexOf(currentUser.toLowerCase() + '-') >= 0 || key.indexOf('-' + currentUser.toLowerCase()) >= 0) {
          child.forEach(function(node){
            var msg = node.val();
            conv.messages.push(msg);
          });
        convs.push(conv);
        console.log(conv);
        }
        var a = document.createElement('a');
        var linkText = document.createTextNode(conv.people);
        a.appendChild(linkText);
        a.href = "/bookings/" + conv.messages[conv.messages.length -1].bookingID + "/messages/new"
        $('#all-messages').append(a);
        console.log(conv.messages[conv.messages.length -1].bookingID);
      });
    });
}
});



