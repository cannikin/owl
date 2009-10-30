function getCookie(c_name) {
  if (document.cookie.length>0) {
    c_start=document.cookie.indexOf(c_name + "=");
    if (c_start!=-1) {
      c_start=c_start + c_name.length+1;
      c_end=document.cookie.indexOf(";",c_start);
      if (c_end==-1) c_end=document.cookie.length;
      return unescape(document.cookie.substring(c_start,c_end));
    }
  }
  return "";
}

watchBlock = {
  
  // set graphs to cookie settings
  setGraphsFromCookie:function() {
    cookies = []
    document.cookie.split(';').each(function(cookie) {
      var key = cookie.split('=').first();
      var value = unescape(cookie.split('=').last());
      values = $H(value.evalJSON());
      values.each(function(pair) {
        var obj = $("watch_"+pair.key+"_"+pair.value);
        if (obj) {
          $("watch_"+pair.key+"_"+pair.value).addClassName('current');
        }
      });
    });
  },
  
  // changes the little graph image in a watch
  changeGraph:function(item, id, type) {
    var element = $("watch_"+id+"_graph");
    element.up().down().childElements().each(function(el) { el.removeClassName('current') });
    $(item).up().addClassName('current');
    element.src = "/watches/response_graph/"+id+"?type="+type+"&"+Date.now();
  },
  
  // updates a watch with new data from the server
  update:function(watch) {
    var container = $('watch_'+watch.id);
    container.down('span.status').update(watch.status.name);
    if (container.down('span.enable')) {
      container.down('span.enable').removeClassName('enable').addClassName('response');
    }
    container.down('span.response').update(watch.last_response_time + ' ms');
    if (container.down('img.graph')) {
      container.down('img.graph').src = '/watches/response_graph/'+watch.id+'?'+Date.now();
    }
    
    // if the container doesn't already contain this class name, we need to change it
    if (!container.hasClassName(watch.status.css)) {
      
      // remove existing class names
      ['up','down','disabled','warning','unknown'].each(function(class_name) {
        container.removeClassName(class_name);
      });
    
      // add current style back in
      container.addClassName(watch.status.css);
    
      // fade the color
      if (watch.status.css == 'warning') {
        container.morph('background-color: #EEBD4E');
      } else if (watch.status.css == 'up') {
        container.morph('background-color: #638562');
      } else if (watch.status.css == 'down') {
        container.morph('background-color: #921C1C');
      } else if (watch.status.css == 'disabled') {
        container.morph('background-color: #aaaaaa');
      } else if (watch.status.css == 'unknown') {
        container.morph('background-color: #666666');
      }
    }

  }
  
}
