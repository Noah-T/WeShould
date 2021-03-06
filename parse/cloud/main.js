
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world! Sweet");
});

Parse.Cloud.define("addFriendToFriendsRelation", function(request, response) {

    Parse.Cloud.useMasterKey();

    var friendRequestId = request.params.friendRequest;
    var query = new Parse.Query("FriendRequest");

    //get the friend request object
    query.get(friendRequestId, {

        success: function(friendRequest) {

            //get the user the request was from
            var fromUser = friendRequest.get("from");
            //get the user the request is to
            var toUser = friendRequest.get("to");

            var relation = fromUser.relation("friendsRelation");
            //add the user the request was to (the accepting user) to the fromUsers friends
            relation.add(toUser);

            //save the fromUser
            fromUser.save(null, {

                success: function() {

                    //saved the user, now edit the request status and save it
                    friendRequest.set("status", "accepted");
                    friendRequest.save(null, {

                        success: function() {

                            response.success("saved relation and updated friendRequest");
                        }, 

                        error: function(error) {

                            response.error(error);
                        }

                    });

                },

                error: function(error) {

                 response.error(error);

                }

            });

        },

        error: function(error) {

            response.error(error);

        }

    });

});