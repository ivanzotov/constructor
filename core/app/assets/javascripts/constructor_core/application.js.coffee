#= require constructor_core/jquery_bundle
#= require constructor_core/bootstrap
#= require ckeditor/ckeditor
#= require constructor_core/urlify
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
  $('#page_url').hide()

  auto_url = $('#page_auto_url').is(':checked')

  unless auto_url
    auto_url_true()

  $('#page_name').keyup -> $('.address').html(parameterize())
  $('#page_parent_id').change ->
    parent_full_url = $('#page_parent_id option:selected').data('full_url')
    if parent_full_url
      $('.path').html(parent_full_url)
    else
      $('.path').html('')

  $('.address, .address_icon').click ->
    if $('#page_auto_url').is(':checked') == true
      $('#page_url').prop('value', parameterize())
      auto_url_true()
    else
      $('.address').html(parameterize())
      auto_url_false()

auto_url_true = ->
  $('#page_url').show()
  $('#page_auto_url').prop('checked', false)
  $('.address_icon').addClass('icon-remove').removeClass('icon-pencil')
  $('.address').hide()

auto_url_false = ->
  $('#page_url').hide()
  $('#page_auto_url').prop('checked', true)
  $('.address_icon').addClass('icon-pencil').removeClass('icon-remove')
  $('.address').show()

parameterize = ->
  URLify($('#page_name').prop('value'))
