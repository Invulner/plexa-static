(function(){$(function(){var n;return n=function(){return $(".login-form__input").each(function(n,i){return $(i).val().trim()?$(i).closest("div").addClass("login-form__input--filled"):$(i).closest("div").removeClass("login-form__input--filled")})},n(),$(document).on("blur input",".login-form__input",function(){return n()}),$(document).on("focus",".login-form__input",function(i){return n(),$(i.target).closest("div").addClass("login-form__input--filled")})})}).call(this);