function my_init() {
  easyrtc.setSocketUrl(":4000");
  easyrtc.setRoomOccupantListener(loggedInListener);
  console.log("Name read:" + $("#self").data("name"));
  easyrtc.setUsername($("#self").data("name"));
  // dontAddCloseButtons();
  easyrtc.easyApp($("#mentor-meeting-container").data("id")+"chatroom", "self", ["caller"],
    function(myId) {
      console.log("App loaded succesfully");
    });

  easyrtc.setPeerListener( function(easyrtcid, msgType, msgData, targeting){
    // switch(msgType){
      // case 'manual_hangup':
        console.log("Manual hangup msg received");
        // easyrtc.hangupAll();
        $("#endcall").submit();
        // break;
      // default:    
        console.log(easyrtc.idToName(easyrtcid) +
            " sent the following data " + JSON.stringify(msgData));
        // break;
      // }
    },'manual_hangup');

  easyrtc.setOnCall( function(easyrtcid, slot) {
    console.log('setOnCall called');
    strong = document.getElementById('awaitingnotification')
    button = document.getElementById('startbutton')
    button.style.display = 'none';
    strong.style.display = 'none' ;
    // creating hang up button
      hangupdiv =  document.getElementById('hangup');
      var hangupbutton = document.createElement('button');
      hangupbutton.onclick = function() {
        occupants = easyrtc.getRoomOccupantsAsArray("default"); //because default room name is 'default'
        destination = occupants.filter(notmyself(easyrtc.myEasyrtcid))[0];
        console.log("Destination to send: " + destination);
        easyrtc.sendPeerMessage(destination, 'manual_hangup', {hangup_method:'button'},
            function(msgType, msgBody ){
               console.log("manual hangup was sent");
            },
            function(errorCode, errorText){
               console.log("Couldn't send hang up to peer");
            }
        );
        console.log('sent that as well');
        easyrtc.hangupAll();
        $("#endcall").submit();
         
        
      }
      hanguplabel = document.createTextNode("End Meeting");
      hangupbutton.appendChild(hanguplabel);
      hangupdiv.appendChild(hangupbutton); 
  });


  //  easyrtc.setOnHangup( function(easyrtcid, slot) {
       
  // });
}

// function to return peer id when used with filter
function notmyself(myid) {
  return function(element) {
      return element != myid;
  }
}


function loggedInListener(roomName, otherPeers) {
  var otherClientDiv = document.getElementById('otherClients');
  while (otherClientDiv.hasChildNodes()) {
    otherClientDiv.removeChild(otherClientDiv.lastChild);
  }

  console.log("Occupants: " + easyrtc.getRoomOccupantsAsArray(roomName));
  


  // console.log("Peer id: " + destination);
  // console.log("My id: " + easyrtc.myEasyrtcid);
 


  if (easyrtc.getRoomOccupantsAsArray(roomName).length === 1){
    console.log("Awaiting guest to join...");
    strong = document.createElement("strong");
    strong.setAttribute("id", "awaitingnotification");
    notification = document.createTextNode("Awaiting guest to join...");
    strong.appendChild(notification);
    otherClientDiv.appendChild(strong);

  }
  else {
    for(var easyrtcid in otherPeers) {
      strong = document.createElement("strong");
      strong.setAttribute("id", "awaitingnotification");
      notification = document.createTextNode(easyrtc.idToName(easyrtcid)+" is available now !");
      strong.appendChild(notification);
      otherClientDiv.appendChild(strong);
      button = document.createElement('button');
      button.setAttribute("id", "startbutton");
      button.onclick = function() {
        performCall(easyrtcid);
      }
      // button.onclick = function(easyrtcid) {
      //   return function() {
      //     performCall(easyrtcid);
      //   }
      // }(i);
      // console.log(easyrtcid);
      label = document.createTextNode("Start Meeting");
      button.appendChild(label);
      otherClientDiv.appendChild(button); 
    }
  }
}


function performCall(easyrtcid) {
  easyrtc.call(
    easyrtcid,
    function(easyrtcid) { console.log("completed call to " + easyrtcid);},
    function(errorMessage) { console.log("err:" + errorMessage);},
    function(accepted, bywho) {
      console.log((accepted?"accepted":"rejected")+ " by " + bywho);
    }
    );
}

$(document).ready(my_init)
$(document).on('page:load', my_init)


// $(window).on('beforeunload', function(){
//     socket.close();
// });