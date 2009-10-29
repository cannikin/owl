// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

watchBlock = {
  changeGraph:function(item, id, type) {
    var element = $("watch_"+id+"_graph");
    element.up().down().childElements().each(function(el) { el.removeClassName('current') });
    $(item).up().addClassName('current');
    element.src = "/watches/response_graph/"+id+"?type="+type;
  },
  
  // updates a watch with new data from the server
  update:function(watch) {
    var container = $('watch_'+watch.id);
    container.down('span.status').update(watch.status.name);
    container.down('span.response').update(watch.last_response_time + ' ms');
    container.down('img.graph').src = '/watches/response_graph/'+watch.id+'?type=last_24';
    
    ['up','down','disabled','warning','unknown'].each(function(class_name) {
      container.removeClassName(class_name);
    });
    
    // add current style back in
    container.addClassName(watch.status.css);
    if (watch.status.css == 'warning') {
      container.morph('background-color: #EEBD4E');
    } else if (watch.status.css == 'up') {
      container.morph('background-color: #638562');
    } else if (watch.status.css == 'down') {
      container.morph('background-color: #921C1C');
    } else if (watch.status.css == 'disabled') {
      container.morph('background-color: #aaaaaa');
    }
  }
}
