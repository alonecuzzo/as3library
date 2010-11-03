module SwfBaseHelper
  def swfaddress_optimizer_javascript_include
    javascript_include_tag  "swfaddress-optimizer.js?flash=8&amp;swfaddress=#{@optimizer_swfaddress}"
  end

  def swfaddress_javascript_includes
    javascript_include_tag 'swfobject', 'swfaddress'
  end
end
