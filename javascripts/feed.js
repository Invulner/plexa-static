(function(){var e,t,i,s,o,a,l,r,d,c,n;t=$(".compose__options"),e=$(".feed-item__dropdown"),a=r=localStorage.getItem("group"),$(".compose__textarea").on("focus",function(e){return e.stopPropagation(),t.slideDown()}),$(document).on("click",function(e){if(!$(e.target).hasClass("compose__textarea")&&!$(e.target).parents(".compose__options").length)return e.stopPropagation(),t.slideUp()}),d=function(e){return e.stopPropagation(),$(e.target).next().toggleClass("feed-item__dropdown--visible")},n=function(){return e.removeClass("feed-item__dropdown--visible")},$(document).on("click",".feed-item__dropdown-trigger",d),$(document).on("click",function(e){if(!$(e.target).hasClass("feed-item__dropdown-trigger"))return n()}),$(document).on("click",".feed-item__likes",function(){var e,t;return e=$(this).find(".feed-item__like-counter"),t=+e.text(),$(this).hasClass("feed-item__likes--active")?e.text(--t):e.text(++t),$(this).toggleClass("feed-item__likes--active")}),$(".feed-filter .filter-checkbox").on("change",function(e){var t,i,s,o;return s=$(e.target).attr("id"),t=$(e.target).is(":checked"),i=localStorage.getItem("filters")?JSON.parse(localStorage.getItem("filters")):[],"allspec"!==s?($("#allspec").prop("checked",!1),o=i.indexOf("allspec"),o>-1&&i.splice(o,1),t?i.push(s):(o=i.indexOf(s))>-1&&i.splice(o,1)):($(".feed-filter__list .filter-checkbox").prop("checked",!1),i=t?[s]:[]),localStorage.setItem("filters",JSON.stringify(i))}),c=JSON.parse(localStorage.getItem("filters")),(null!=c?c.length:void 0)&&($(".feed-filter .filter-checkbox").prop("checked",!1),c.map(function(e){return $(".feed-filter #"+e).prop("checked",!0)})),$(".compose__tab").on("click",function(){var e;return e=$(this).attr("data-tab"),$(".compose__tab").removeClass("compose__tab--active"),$(this).addClass("compose__tab--active"),$(".compose-tab-content").addClass("compose-tab-hidden"),$(".compose__"+e).removeClass("compose-tab-hidden")}),$(".compose__section li").on("click",function(){var e;if(e=$(this).parents("ul"),e.find("li").removeClass("list-item--active"),$(this).toggleClass("list-item--active"),e.hasClass("compose__groups-list"))return r=$(this).text()}),$(".feed-filter__list.nav__groups li").on("click",function(){return localStorage.setItem("group",$(this).text()),window.location.href="group-feed.html"}),a&&($(".compose__groups-list li").removeClass("list-item--active"),$(".feed-filter__list.nav__groups li").removeClass("list-item--active"),o=$(".compose__groups-list li").filter(function(e,t){return $(t).text()===a}),o.addClass("list-item--active"),l=$(".feed-filter__list.nav__groups li").filter(function(e,t){return $(t).text()===a}),l.addClass("list-item--active"),$(".group-strip__title").text(a)),i=$(".compose__post-btn"),s=$(".compose__textarea"),s.on("input",function(){var e;return e=$(this).val(),e.trim().length?i.removeAttr("disabled"):i.prop("disabled","disabled")}),i.on("click",function(e){var t,i;return e.preventDefault(),t=s.val(),s.val(""),i="<div class='feed-item'><div class='feed-item__header'> <a class='feed-item__avatar-block' href='/profile.html'> PT </a> <div class='feed-item__header-main'> <div class='feed-item__header-row'> <a class='feed-item__author' href='/profile.html'> Plexa Test </a> <a class='feed-item__story-link' href='javascript:void(0)'> <time class='feed-item__time time timeago'>1 min ago</time> </a> </div> <div class='feed-item__header-aux' style='width: calc(100% - 143px);'> <span class='feed-item__label feed-item__label--group'> "+r+" </span> <div class='feed-item__dropdown-wrapper'> <a class='feed-item__dropdown-trigger feed-item__triangle-trigger' href='javascript: void(0)'></a> <div class='feed-item__dropdown feed-item__dropdown--arrow-trigger'> <div class='feed-item__dropdown-section'><a href='javascript:void(0)' class='feed-item__dropdown-link feed-item__edit'><i class='feed-item__dropdown-item-icon glyphicon glyphicon-pencil'></i> Edit</a><a href='javascript:void(0)' class='feed-item__dropdown-link feed-item__delete'><i class='feed-item__dropdown-item-icon glyphicon glyphicon-remove-circle'></i> Delete</a></div> </div> </div> </div> <span class='feed-item__label feed-item__label--position'> Doctor </span> </div> </div> <div class='feed-item__body'> <p class='feed-item__text'>"+t+"</p> </div> <div class='feed-item__comments-region'></div> <div class='feed-item__footer share-data'> <div class='feed-item__stats'><span class='feed-item__likes icon-like'> <span class='feed-item__like'>Like</span> <svg> <use xlink:href='#like-icon' xmlns:xlink='http://www.w3.org/1999/xlink'></use> </svg> <span class='feed-item__like-counter'>0</span> </span></div> <form class='feed-item__reply-form'><textarea class='feed-item__reply-input' rows='1' placeholder='Type your reply' style='height: 36px;'></textarea> <button class='feed-item__reply-btn' type='submit' disabled='disabled'></button></form> </div></div>",$(".feed-items").prepend(i)})}).call(this);