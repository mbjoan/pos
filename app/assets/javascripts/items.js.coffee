# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


document.getElementById("item_search").style.margin-top =5;
document.getElementById("new_sale").style.visibility = "hidden";



$ ->
  $('#item_search').typeahead
    name: "item"
    remote: "/items/autocomplete?query=%QUERY"


