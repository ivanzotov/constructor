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

