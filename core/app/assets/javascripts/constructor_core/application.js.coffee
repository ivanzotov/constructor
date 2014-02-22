#= require constructor_core/jquery_bundle
#= require ckeditor/ckeditor
#= require constructor_pages/urlify
#= require ./jquery.ui.nestedSortable
#= require ./sortable_tree/initializer
#= require ./expandable_tree/hashchange
#= require ./expandable_tree/restorable
#= require ./expandable_tree/initializer
#= require_self

$(document).ready ->
  $('.auto_url').hide()
  $('#page_url').hide()

  auto_url = $('#page_auto_url').is(':checked')

  unless auto_url
    auto_url_true()

  $('#page_name').keyup -> $('.b-full-url__url').html(parameterize())
  $('#page_parent_id').change ->
    parent_full_url = $('#page_parent_id option:selected').data('full_url')
    if parent_full_url
      $('.b-full-url__path').html(parent_full_url)
    else
      $('.b-full-url__path').html('')

  $('.b-full-url__url, .b-full-url__icon').click ->
    if $('#page_auto_url').is(':checked') == true
      $('#page_url').prop('value', parameterize())
      auto_url_true()
    else
      $('.b-full-url__url').html(parameterize())
      auto_url_false()

auto_url_true = ->
  $('#page_url').show()
  $('#page_auto_url').prop('checked', false)
  $('.b-full-url__icon').addClass('fa-times-circle-o').removeClass('fa-pencil')
  $('.b-full-url__url').hide()

auto_url_false = ->
  $('#page_url').hide()
  $('#page_auto_url').prop('checked', true)
  $('.b-full-url__icon').addClass('fa-pencil').removeClass('fa-times-circle-o')
  $('.b-full-url__url').show()

parameterize = ->
  URLify($('#page_name').prop('value'))
