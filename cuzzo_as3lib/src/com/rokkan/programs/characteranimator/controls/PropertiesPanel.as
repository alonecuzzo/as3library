package com.rokkan.programs.characteranimator.controls 
{
	import com.rokkan.math.Format;
	import com.rokkan.programs.characteranimator.Main;
	import com.rokkan.programs.characteranimator.parts.BoxRotator;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class PropertiesPanel extends Sprite 
	{
		// inherent vars
		public var panelTitle_txt:TextField;
		
		private var _currentPanel;
		
		public function PropertiesPanel() 
		{
			
		}
		
		public function init( target ) {
			if (_currentPanel != null) {
				this.removeChild( _currentPanel );
			}
			
			if ( target is BoxRotator ) {
				_currentPanel = new PropertiesPanelObject3d();
				panelTitle_txt.text = "Properties - " + target.id;
				
			}else if ( target is TimeLineKeyFrame ) {
				_currentPanel = new PropertiesPanelKeyFrame();
				panelTitle_txt.text = "Properties - " + target.frame;
			}
			
			this.addChild( _currentPanel );
			_currentPanel.init( target );
		}

		public function die() {
			if (_currentPanel != null && _currentPanel.die!=null)
				_currentPanel.die();
		}
	}
	
}