// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

watchBlock = {
  changeGraph:function(item, id, type) {
    var element = $("watch_"+id+"_graph");
    element.up().down().childElements().each(function(el) { el.removeClassName('current') });
    $(item).up().addClassName('current');
    element.src = "/watches/response_graph/"+id+"?type="+type;
  }
}
