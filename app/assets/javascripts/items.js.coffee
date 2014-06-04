# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


document.getElementById("item_search").style.visibility = "hidden";

jQuery ->
    completer = new GmapsCompleter
        inputField: '#item_search'
        errorField: '#gmaps-error'

    completer.autoCompleteInit
        country: "us"


$ ->
  $('#item_search').typeahead.bundle
    name: "item"
    remote: "/items/autocomplete?query=%QUERY"


