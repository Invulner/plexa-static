(function(){var e,t,o,i,r;t=$(".compose__options"),e=$(".feed-item__dropdown"),$(".compose__textarea").on("focus",function(e){return e.stopPropagation(),t.slideDown()}),$(document).on("click",function(e){if(!$(e.target).hasClass("compose__textarea")&&!$(e.target).parents(".compose__options").length)return e.stopPropagation(),t.slideUp()}),o=function(e){return e.stopPropagation(),$(e.target).next().toggleClass("feed-item__dropdown--visible")},r=function(){return e.removeClass("feed-item__dropdown--visible")},$(document).on("click",".feed-item__dropdown-trigger",o),$(document).on("click",function(e){if(!$(e.target).hasClass("feed-item__dropdown-trigger"))return r()}),$(document).on("click",".feed-item__likes",function(){var e,t;return e=$(this).find(".feed-item__like-counter"),t=+e.text(),$(this).hasClass("feed-item__likes--active")?e.text(--t):e.text(++t),$(this).toggleClass("feed-item__likes--active")}),$(".feed-filter .filter-checkbox").on("change",function(e){var t,o,i,r;return i=$(e.target).attr("id"),t=$(e.target).is(":checked"),o=localStorage.getItem("filters")?JSON.parse(localStorage.getItem("filters")):[],"allspec"!==i?($("#allspec").prop("checked",!1),r=o.indexOf("allspec"),r>-1&&o.splice(r,1),t?o.push(i):(r=o.indexOf(i))>-1&&o.splice(r,1)):($(".feed-filter__list .filter-checkbox").prop("checked",!1),o=t?[i]:[]),localStorage.setItem("filters",JSON.stringify(o))}),i=JSON.parse(localStorage.getItem("filters")),i.length&&($(".feed-filter .filter-checkbox").prop("checked",!1),i.map(function(e){return $(".feed-filter #"+e).prop("checked",!0)}))}).call(this);