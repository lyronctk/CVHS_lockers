
jQuery(document).ready(function() {

    /*
        Background slideshow
    */
    $.backstretch([
      "assets/stylesheets/img/backgrounds/1.jpg"
    , "assets/stylesheets/img/backgrounds/2.jpg"
    , "assets/stylesheets/img/backgrounds/3.jpg"
    , "assets/stylesheets/img/backgrounds/4.jpg"
    , "assets/stylesheets/img/backgrounds/5.jpg"
    , "assets/stylesheets/img/backgrounds/6.jpg"
     , "assets/stylesheets/img/backgrounds/7.jpg"
    ], {duration: 4000, fade: 750});

    /*
        Tooltips
    */
    $('.links a.home').tooltip();
    $('.links a.blog').tooltip();

    /*
        Form validation
    */
    $('.register form').submit(function(){
        $(this).find("label[for='firstname']").html('First Name');
        $(this).find("label[for='lastname']").html('Last Name');
        $(this).find("label[for='username']").html('Username');
        $(this).find("label[for='email']").html('Email');
        $(this).find("label[for='password']").html('Password');
        ////
        var firstname = $(this).find('input#firstname').val();
        var lastname = $(this).find('input#lastname').val();
        var username = $(this).find('input#username').val();
        var email = $(this).find('input#email').val();
        var password = $(this).find('input#password').val();
        if(firstname == '') {
            $(this).find("label[for='firstname']").append("<span style='display:none' class='blue'> - Please enter your first name.</span>");
            $(this).find("label[for='firstname'] span").fadeIn('medium');
            return false;
        }
        if(lastname == '') {
            $(this).find("label[for='lastname']").append("<span style='display:none' class='blue'> - Please enter your last name.</span>");
            $(this).find("label[for='lastname'] span").fadeIn('medium');
            return false;
        }
        if(username == '') {
            $(this).find("label[for='username']").append("<span style='display:none' class='blue'> - Please enter a valid username.</span>");
            $(this).find("label[for='username'] span").fadeIn('medium');
            return false;
        }
        if(email == '') {
            $(this).find("label[for='email']").append("<span style='display:none' class='blue'> - Please enter a valid email.</span>");
            $(this).find("label[for='email'] span").fadeIn('medium');
            return false;
        }
        if(password == '') {
            $(this).find("label[for='password']").append("<span style='display:none' class='blue'> - Please enter a valid password.</span>");
            $(this).find("label[for='password'] span").fadeIn('medium');
            return false;
        }
    });


});


