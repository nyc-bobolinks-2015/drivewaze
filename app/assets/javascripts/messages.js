var myDataref = new Firebase('https://drivewaze.firebaseio.com/');

document.addEventListener('DOMContentLoaded', function(){

  if($('#toUser').length) {

    var msgData = document.getElementById('msg-data-carrier').dataset;
    var fromUser = document.getElementById('fromUser').value;
    var toUser = document.getElementById('toUser').value;
    var convUsers = [fromUser.toLowerCase(), toUser.toLowerCase()].sort().join('-');
    var ids = [msgData.fromUserId, msgData.toUserId].sort().join('-') + '-' + msgData.bookingId;
    var targetNode = 'msgs/' + ids;

  $(".new-message-container").on("submit", "#form", function(event){
  event.preventDefault();
    var messageObj = {
          sent_at: String(new Date()),
          fromUser: fromUser,
          toUser:  toUser,
          message: document.getElementById('msgText').value
        };
    var node  = myDataref.child(targetNode);
    node.child('info').set({users: convUsers,
      address: msgData.address,
      booking: msgData.bookingId});

    node.child('messages').push(messageObj);
    $("#msgText").val("");

  });

  myDataref.child(targetNode).on("value", function(snapshot) {
    var element = document.getElementById('messages');
    var output = '';
    snapshot.forEach(function(child){
      var conv = child;
      conv.forEach(function(child){
          var currentUser = $("#fromUser").val();
          var receiver = $("#toUser").val();
          var msg = child.val();
        if (msg instanceof Object){
          if (child.val().fromUser == currentUser) {
            output += ("<div class='bubble bubble--alt'>" + msg.sent_at + "<br>" +"From: " + msg.fromUser + " To: " + msg.toUser + "<br>" + msg.message + "<br></div>");
          }else {
            output += ("<div class='bubble'>" + msg.sent_at + "<br>" +"From: " + msg.fromUser + " To: " + msg.toUser + "<br>" + msg.message + "<br></div>");
          };
        };
      });
      element.innerHTML = output;
      //animates the scroll down
      $('#messages').scrollTop($('#messages')[0].scrollHeight);
    });
  });
}

function Conversation(args) {
  this.users = args.info.users;
  this.bookingId = args.info.booking;
  this.address = args.info.address;
  this.messages = [];
}
function Message(args) {
  this.fromUserName = args.fromUser;
  this.toUserName = args.toUser;
  this.message = args.message;
  this.sentAt = new Date(args.sent_at);
}

if ($('#all-messages').length) {
    var specificNode = 'msgs';
    myDataref.child(specificNode).on("value", function(snapshot) {
      var convs = [];
      var conv;
      snapshot.forEach(function(child){
        if (child.val().info) {
          conv = new Conversation(child.val());
        }
        if (child.val().messages) {
          child.forEach(function(child){
            var msgColl = child.val();
            for (var msg in msgColl) {
              if (msgColl[msg].fromUser) {
                conv.messages.push(new Message(msgColl[msg]));
              }
            }
          });
        }
        if (conv) {
          convs.push(conv);
        }
      });

      convs.forEach(function(conv){
        var theLink = '<div><a class="btn btn-default" href="/bookings/' +
          conv.bookingId + '/messages/new">' + conv.users +
          ' (' + conv.messages.length +
          (conv.messages.length == 1 ? 'message' : ' messages' ) +
            ')</a> ' + "<br>" + "Regarding your booking at: " + conv.address + '</div>';
        $('#all-messages').append(theLink);
      });
    });
}
});

