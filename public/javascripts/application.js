// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.fn.enable_hint = function()
  {
    jQuery(this).val(jQuery(this).attr('hint'));
    jQuery(this).addClass("hint");
    
    jQuery(this).bind('focus', function()
    {
      if(jQuery(this).val() == jQuery(this).attr('hint'))
      {
        jQuery(this).val("");
        jQuery(this).removeClass("hint");
      }
    })
    
    jQuery(this).bind('blur', function()
    {
      if(jQuery(this).val() == "")
      {
        jQuery(this).val(jQuery(this).attr('hint'));
        jQuery(this).addClass("hint");
      }
    })
  }
  
jQuery(document).ready(function(){
  jQuery.each(jQuery("[hint]"), function()
  {
    jQuery(this).enable_hint();
  })  
})


function extract_parameters_from(form)
{
  var params = "";
  
  jQuery.each(form.find("input").get(), function()
  {
    params += "&" + jQuery(this).attr("name") + "=" +  escape(jQuery(this).attr("value")).replace(/\+/g, "%2B")
  });

  jQuery.each(form.find("textarea").get(), function()
  {
    params += "&" + jQuery(this).attr("name") + "=" +  escape(this.value).replace(/\+/g, "%2B")
  });
  
  return params;
}