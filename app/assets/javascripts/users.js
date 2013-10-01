$submitUser = $("#submitUser");
$submitUser.bind('click',function(e){
	e.preventDefault();
	validateUserForm();
});

function validateUserForm(){
/* Get user list we need for validations */

var userList;
$.ajax({
	url: app_path + "/users.json",
	async: false,
	success: function(data){
		userList = data;
	}
});

var errors = [];

var uName = $('#user_username').value

/* Validate user name is non-blank */
if (uName == ""){
	errors.push("User name cannot be blank")
}


/* Validate that the user name isn't already taken */

var userExists = false;
for (i = 0; i < userList.length; i++){
	if (userList[i].username == uName){
		userExists = true;
	}
}
if (userExists){
	errors.push("User " + uName + " already exists.");
}

/* Submit the form if there are no validation errors */
if (errors.length == 0){
	$('#submitUser').closest('form').submit();
}
else{
	var $modalContainer = $('#modalContainer');
	$modalContainer.find('.alert-box').remove();
	$.each(errors,function(i,v){
		$modalContainer.find('.errors').append("<div data-alert class='alert-box alert'>" + v + "</div>");
	});
	
}	


}