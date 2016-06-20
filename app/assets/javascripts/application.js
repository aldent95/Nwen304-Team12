// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .


function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length,c.length);
        }
    }
    return "";
}

$(function() {
    var auth = getCookie("auth");
    var user_id = getCookie("id");

    onload(auth, user_id);
});

function onload(auth, id){

    if(auth != "" && id != ""){
        var cb2 = function(){
            var cb = function(data){
                $(".js-logged-in-links").removeClass("hide");
                $(".js-logged-out-links").addClass("hide");
                $(".js-welcome-user").text("Welcome " +data.data.name + "!");
            };
            getUser(id, cb);
        };
        checkLogin(auth, id, cb2);


    }
}


function getUser(id, callback){
    console.log(id);
    $.ajax({
        url: 'm_users/' + id,
        type: "GET",
        dataType: "json",
        success: callback
    });
}

function checkLogin(auth, id, callback){
    console.log(id);
    $.ajax({
        url: '/loggedin',
        type: "GET",
        dataType: "json",
        data: {auth_token: auth, user_id: id},
        success: function(data){
            if(data.status == 200){
                callback()
            }
            else{
                $(".js-errors").append("<div class='alert alert-danger' role='alert'>" + responseData.message + '</div>');
            }
        }
    });
}

