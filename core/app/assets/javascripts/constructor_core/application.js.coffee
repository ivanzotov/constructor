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

  $('.js-sortable').sortable()

  $('.b-alert__close').click (e) ->
    e.preventDefault()
    $('.b-alert').slideUp()

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

  $('html').click (e) ->
    if !$(e.target).is('.b-tree__edit-name')
      reset_edit_page()

$(document).on 'click', '.b-tree__add', (e) ->
  e.preventDefault()
  self = this
  $.post '/admin/pages/'+$(this).data('id')+'/create_child', {template_id: $(this).data('template-id')}, (data) ->
    $(self).parent().parent().parent().find('ol').append(data)
    $(self).parent().parent().parent().find('ol').find('li:last-child').find('.b-tree__edit').click()

$(document).on 'click', '.b-tree__remove', (e) ->
  e.preventDefault()
  self = this
  if confirm('Вы уверены?')
    $.post '/admin/pages/'+$(this).data('id'), {'_method': 'delete'}, ->
      $(self).parent().parent().hide()

$(document).on 'click', '.b-tree__edit', (e) ->
  e.preventDefault()

  reset_edit_page()

  $(this).css('opacity', '0')
  $(this).siblings('.b-tree__edit-name-ok').show()
  $(this).parent().find('.b-tree__edit-name').val($(this).parent().find('.b-tree__name').text())
  $(this).parent().find('.b-tree__name').hide()
  $(this).parent().find('.b-tree__edit-name').show().focus()

$(document).on 'keypress', '.b-tree__edit-name', (e) ->
  if e.which == 13
    $(this).siblings('.b-tree__edit-name-ok').click()

$(document).on 'click', '.b-tree__edit-name-ok', (e) ->
  e.preventDefault()
  e.stopPropagation()

  _value = $(this).siblings('.b-tree__edit-name').val()
  self = this

  $.post '/admin/pages/'+$(this).data('id'), {'_method': 'put', page: {name: _value}}, ->
    $(self).parent().find('.b-tree__name').text(_value)


$(document).on 'click', '.b-tree__edit-name', (e) ->
  e.stopPropagation()
  e.preventDefault()

reset_edit_page = ->
  $('.b-tree__name').show()
  $('.b-tree__edit-name').hide()
  $('.b-tree__edit').css('opacity', '1')
  $('.b-tree__edit-name-ok').hide()

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
