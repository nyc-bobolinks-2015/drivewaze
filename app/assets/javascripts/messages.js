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
          message: document.getElementById('msgText').value
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
    var currentUser = $("#current_user_nav").text();
    var specificNode = 'msgs/laura-sam' //currentUser.toLowerCase() +
    // debugger;
    myDataref.child(specificNode).on("child_added", function(snapshot) {
      var allMessages = document.getElementById('all-messages');
      var newPost = snapshot.val();
      allMessages.innerHTML = "From: " +  newPost.fromUser + "<br>" + "Most recent message: " +newPost.message
      });
}
});



