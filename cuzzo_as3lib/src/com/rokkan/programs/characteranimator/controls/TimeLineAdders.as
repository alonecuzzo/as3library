package com.rokkan.programs.characteranimator.controls 
{
	import com.rokkan.programs.characteranimator.Main;
	import com.rokkan.programs.characteranimator.shared.Preferances;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.*;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class TimeLineAdders extends Sprite
	{
		// inherent vars
		public var btnGuide_mc:MovieClip;
		public var btnSound_mc:MovieClip;
		
		private var currentFile:File;
		private var stream:FileStream = new FileStream();
		
		public function TimeLineAdders() 
		{
			
		}
		
		public function init() {
			
			btnSound_mc.buttonMode = true;
			btnSound_mc.addEventListener( MouseEvent.CLICK, addSound, false, 0, true);
			btnGuide_mc.buttonMode = true;
			btnGuide_mc.addEventListener( MouseEvent.CLICK, addGuide, false, 0, true);
		}
		
		private function addSound( e:Event = null ) {
			trace("ADD SOUND");
			openSoundFile();
		}
		
		private function addGuide( e:Event = null ) {
			currentFile = Preferances.lastDirectory;
			var fileFilter = new FileFilter("Image File", "*.jpg;*.png");
			currentFile.browseForOpen("Open", [fileFilter]);
			currentFile.addEventListener(Event.SELECT, openGuideSelected);
		}
		
		private function openGuideSelected(event:Event):void 
		{
			currentFile.removeEventListener(Event.SELECT, openSoundSelected);
			Main.mainRef.timeLine_mc.addGuideItem( currentFile.url );
			
			
			Preferances.lastDirectory = currentFile;
		}
		
		private function openSoundFile() {
			currentFile = Preferances.lastDirectory;
			var fileFilter = new FileFilter("MP3 File", "*.mp3");
			currentFile.browseForOpen("Open", [fileFilter]);
			currentFile.addEventListener(Event.SELECT, openSoundSelected);
		}
		
		private var sc:SoundChannel;
		
		private function openSoundSelected(event:Event):void 
		{
			currentFile.removeEventListener(Event.SELECT, openSoundSelected);
			Main.mainRef.timeLine_mc.addSoundItem( currentFile.url );
			
			
			Preferances.lastDirectory = currentFile;
		}
		
		private function readIOErrorHandler(event:Event):void { trace("The specified currentFile cannot be opened."); }
		
		private function writeIOErrorHandler(event:Event):void { trace("The specified currentFile cannot be saved."); }
		
	}
	
}