jQuery.noConflict();

var setUpSnips = function() {
  
  var scissors = jQuery.browser.msie ? '<font face="Wingdings">&#34;</font>' : '&#9986;'

  jQuery('.snip').unbind()
    .each(function(){
      var child = jQuery(this).children()[0]    
      var disp = child ?  jQuery(child).css("display") : "inline"
      jQuery(this).css("display", disp)
      if(jQuery(this).css("position") != "absolute")
        jQuery(this).css("position", "relative")
      
      jQuery(this).append(jQuery('<div class=snip_edit>edit ' + scissors + ' </div>'))
      
    })
    
    jQuery('.snip .snip_edit')
      .click(function(){
        var snip = jQuery(this).parent()
        var snip_id = jQuery(snip).attr("snip")
        clearSelection()
        if(snip_id) {
        
          url = '/snips/' + snip_id + '/edit';
          jQuery.ajax(
            {
              type: "GET",
              url: url, 
            
              success: function(text) {
                var Old_html = jQuery(snip).html()
                
                jQuery(snip)
                  .html(text)
                  .find('form').submit(function(data) {
                    jQuery(this).ajaxSubmit( {
                        success: function(data) {
                          snip.replaceWith(data);
                          setUpSnips()
                        }
                      }
                    );

                  return false
                }).find("#cancel").click(function(){
                  jQuery(snip).html(Old_html)
                })
              
                 var width = jQuery(snip).width()                  
                  jQuery('#snip_raw_text').css("width", width)
              }
          })
        return false
        }
      })
    
    jQuery('.missing_snip a').unbind().click(function(){
      document.location.href = jQuery('this').attr("href");
    })
  
}


function clearSelection() {
  var sel ;
  if(document.selection && document.selection.empty){
    document.selection.empty() ;
  } 
  else if(window.getSelection) {
    sel=window.getSelection();
    if(sel && sel.removeAllRanges)
      sel.removeAllRanges() ;
  }
}


jQuery(document).ready(function() {
  jQuery.ajaxSetup({ 
    'beforeSend': function(xhr) {xhr.setRequestHeader("Accept",
      "text/javascript")} 
  }) 

  setUpSnips()
})
