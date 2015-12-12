var myDataref = new Firebase('https://drivewaze.firebaseio.com/');

document.addEventListener('DOMContentLoaded', function(){


  document.getElementById('form').addEventListener('submit', function(event){
  event.preventDefault();

    var fromUser = document.getElementById('fromUser').value;
    var toUser = document.getElementById('toUser').value;
    var messageObj = {
          sent_at: String(new Date()),
          fromUser: fromUser,
          toUser:  toUser,
          message: document.getElementById('msgText').value
        };

    var dest = 'msgs/' + [fromUser.toLowerCase(), toUser.toLowerCase()].sort().join('-');

    var node  = myDataref.child(dest);
    node.push(messageObj);

    var clearField = $("#msgText")
    clearField.val("");

  });
    var currentUser = $('a')[0].text;
    var provider = $('#toUser').val();
    var myNode = 'msgs/' + [currentUser.toLowerCase(), provider.toLowerCase()].sort().join('-');
    myDataref.child(myNode).on("value", function(snapshot) {

      var element = document.getElementById('messages');
      // debugger;
      var output = '';
      snapshot.forEach(function(child){
        var msg = child.val();
        output += ("From: " + msg.fromUser + " To: " + msg.toUser + "<br>" + msg.message + "<br>" + msg.sent_at +
          "<br>");
        // debugger;
      });
      element.innerHTML = output;
    });



});



