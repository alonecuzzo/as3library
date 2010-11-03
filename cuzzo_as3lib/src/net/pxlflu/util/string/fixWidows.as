package com.atmospherebbdo.util.string
{
	import com.atmospherebbdo.util.string.NON_BREAKING_SPACE;
	
	import flash.text.TextField;	
	
	/**
	 * Attempts to fix widows in a multiline text field.
	 * 
	 * @param	tf	TextField
	 */
	public function fixWidows( tf:TextField ) :void
	{
		if (tf.numLines <= 1)
		{
			// only one line
			return;
		}
		if (tf.text.split(/\w/).length <= 2)
		{
			return;
		}
		
		// replace the last space found with a non-breaking space
		var fixer:RegExp = /\s([A-Za-z\.\?\!]+)$/mg;
		tf.text = tf.text.replace(fixer, NON_BREAKING_SPACE + "$1");
		
		// TODO: if the resulting last line now breaks within the last word,
		// undo it and live with the widow
		
		// TODO: test the hell out of this
	}}