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

  auto_url = $('#page_auto_url').is(':checked')

  unless auto_url
    auto_url_true()

  $('.address, .address_icon').click ->
    if $('#page_auto_url').is(':checked') == true
      auto_url_true()
    else
      auto_url_false()

auto_url_true = ->
  $('.page_url').show()
  $('#page_auto_url').prop('checked', false)
  $('.address_icon').addClass('icon-remove').removeClass('icon-pencil')
  $('.address').hide()

auto_url_false = ->
  $('.page_url').hide()
  $('#page_auto_url').prop('checked', true)
  $('.address_icon').addClass('icon-pencil').removeClass('icon-remove')
  $('.address').show()