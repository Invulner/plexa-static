(function(){var t,e,o;t=$(".grid-posts"),o=function(){return t.addClass("visible")},t.imagesLoaded(function(){return t.masonry(function(){return{itemSelector:".grid-post-item"}}),t.masonry("layout"),setTimeout(function(){return o()},100)}),e=localStorage.getItem("magnet-type"),$(".share-modal").addClass("share-modal--"+e),$(".new-post-modal__btn").on("click",function(t){return t.preventDefault(),t.stopPropagation(),flashMessage.show("success","Post 'Title' successfully posted to Twitter/Facebook/Linkedin.")})}).call(this);