#= require constructor_core/jquery_bundle
#= require constructor_core/bootstrap
#= require ckeditor/ckeditor
#= require_self

$(document).ready ->
  $('#tree').treeview({
    collapsed: false,
    persist: 'cookie'
  })
  
  $(".alert").alert()
  $(".collapse").collapse()
  
  $('#url-if-empty').popover({
    offset: 10
  })

  $('.auto_url').hide()
  $('.page_url').hide()

  auto_url = $('.auto_url input').is(':checked')

  auto_url_true()

  if auto_url == false
    url_true()
    auto_url_false()

auto_url_true = ->
  $('.address, .url .icon-pencil').click ->
    url_true()
    auto_url_false()

auto_url_false = ->
  $('.address, .url .icon-remove').click ->
    url_false()
    auto_url_true()

url_true = ->
  $('.page_url').show()
  $('.auto_url input').attr('checked', false)
  $('.address_icon').addClass('icon-remove').removeClass('icon-pencil')
  $('.address').hide()

url_false = ->
  $('.page_url').hide()
  $('.auto_url input').attr('checked', true)
  $('.address_icon').addClass('icon-pencil').removeClass('icon-remove')
  $('.address').show()