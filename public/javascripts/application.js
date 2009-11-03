// Called when the browser is resized to resize each of the slides in the compact dashboard view
function resizePanels() {
  var watches = $$('.watch');
  var container_margin = $('sites').getStyle('marginLeft').match(/\d+/);  // how much space we need to reserve for the margins of the page
  var browser_width = parseInt(document.viewport.getWidth());             // browser width
  var watch_margin = parseInt(watches.first().getStyle('marginRight').match(/\d+/));  // how much margin for each watch
  var watch_min_width = parseInt(watches.first().getStyle('minWidth').match(/\d+/));  // the minimum width a watch is allowed to be
  var i = watches.length;
  
  // start counting backwards through the number of total watches until we find a width for each that is greater than the max width
  do {
    var watch_width = figureWatchWidth(browser_width, i, watch_margin, container_margin);  // how wide one slide should be
    i--;
  } while (watch_width < watch_min_width)

  // resize each slide
  watches.each(function(element) {
    element.setStyle({'width':watch_width+'px'});
    resizeLink(element, watch_width);
    resizeName(element, watch_width);
  });
  
}

// resizes the link in a watch so it doesn't wrap
function resizeLink(element, width) {
  var url = element.down('span.full_url').innerHTML.replace(/https?:\/\//,'');
  var a = element.down('span.url a');
  var font_size = a.getStyle('fontSize').replace(/px/,'');
  a.update(resizeText(url, font_size, width, 1.7, 'middle'));
}


function resizeName(element, width) {
  var full_name = element.down('span.full_name').innerHTML;
  var name = element.down('span.name');
  var font_size = name.getStyle('fontSize').replace(/px/,'');
  name.update(resizeText(full_name, font_size, width, 1.4, 'end'));
}


// resizes text based on a certain element size
// text => the text to resize
// font_size  => the size of the current font
// width => how wide of a space the font needs to fit
// font_factor => multiplier that compensates for font width (something like 1.5)
// shorten_at => where to shorten the text (and replace with ellipsis) - start, middle, end
function resizeText(text, font_size, width, font_factor, shorten_at) {
  var chars = width / font_size * font_factor;
  if (text.length > chars) {
    switch (shorten_at) {
    case 'start':
      return '...' + text.slice(-1,-chars);
      break;
    case 'middle':
      return text.slice(0,(chars/2)) + '...' + text.slice(-(chars/2));      // shorten the URL if it's too long, removing http:// at the beginning
      break;
    case 'end':
      return text.slice(0,chars) + '...';
      break;
    }
  } else {
    return text
  }
}


// computes how wide one slide should be
function figureWatchWidth(browser_width,total,watch_margin,container_margin) {
  return (browser_width / total - watch_margin) - (container_margin /total);  // how wide one slide should be
}

// reads cookies
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

// methods used by watches
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
