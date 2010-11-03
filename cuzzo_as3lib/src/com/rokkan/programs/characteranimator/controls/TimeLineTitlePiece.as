package com.rokkan.programs.characteranimator.controls 
{
	import com.rokkan.net.LoadingQueue;
	import com.rokkan.programs.characteranimator.parts.BoxRotator;
	import com.rokkan.programs.characteranimator.shared.Preferances;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.filesystem.*;
	import flash.events.*;
	import flash.system.Capabilities;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class TimeLineTitlePiece extends Sprite 
	{
		public var downDirectory_mc:MovieClip;
		public var right_mc:MovieClip;
		
		// created vars
		private var _target:BoxRotator;
		private var _level:Number;
		private var _currentFile:File;
		private var _loadingQueue:LoadingQueue;
		// The FileStream object used for reading and writing the currentFile
		private var stream:FileStream = new FileStream();
		
		public function TimeLineTitlePiece() 
		{
			_loadingQueue = new LoadingQueue();
		}
		
		public function init( target:BoxRotator, level:Number ) {
			_target = target;
			_level = level;
			
			if (level <= 0) {
				downDirectory_mc.visible = false;
			}else {
				downDirectory_mc.x = 5 + 8 * (level-1);
				right_mc.x = 10 + 8 * level;
				
				right_mc.btnRemove_mc.x = right_mc.btnRemove_mc.x - level * 8 - 7;
				right_mc.btnAdd_mc.x = right_mc.btnAdd_mc.x - level * 8 - 7;
				right_mc.btnLoadObj_mc.x = right_mc.btnLoadObj_mc.x - level * 8 - 7;
				right_mc.btnTexture_mc.x = right_mc.btnTexture_mc.x - level * 8 - 7;
			}
			
			right_mc.title_txt.text = _target.id;
			right_mc.btnLoadObj_mc.buttonMode = true;
			right_mc.btnLoadObj_mc.addEventListener(MouseEvent.CLICK, loadObj, false, 0, true);
			
			right_mc.btnAdd_mc.buttonMode = true;
			right_mc.btnAdd_mc.addEventListener(MouseEvent.CLICK, addCube, false, 0, true);
			
			right_mc.btnTexture_mc.buttonMode = true;
			right_mc.btnTexture_mc.addEventListener(MouseEvent.CLICK, loadTexture, false, 0, true);
		}
		
		private function loadTexture( e:MouseEvent ) {
			var fileChooser:File = Preferances.lastDirectory;
			
			var fileFilter = new FileFilter("Image File", "*.jpg;*.gif;*.png");
			fileChooser.browseForOpen("Open", [fileFilter]);
			fileChooser.addEventListener(Event.SELECT, fileOpenImageSelected);
		}
		
		private function fileOpenImageSelected(event:Event):void 
		{
			_currentFile = event.target as File;
			//_target.loadObj( _currentFile.url, 10 );
			Preferances.lastDirectory = _currentFile;
			
			_target.loadExternalTexture( _currentFile.url );
		}
		
		private function addCube( e:MouseEvent = null) {
			var addNewBox:AddNewBox = new AddNewBox();
			this.parent.addChild( addNewBox );
			addNewBox.x = this.x + this.parent.x + right_mc.x + right_mc.btnAdd_mc.x - 1;
			addNewBox.y = this.y + this.parent.y - 18;
			addNewBox.init( _target, _level, this );
		}
		
		private function loadObj(e:MouseEvent = null) {
			var fileChooser:File = Preferances.lastDirectory;
			
			var fileFilter = new FileFilter("OBJ File", "*.obj");
			fileChooser.browseForOpen("Open", [fileFilter]);
			fileChooser.addEventListener(Event.SELECT, fileOpenOBJSelected);
		}
		
		private function fileOpenOBJSelected(event:Event):void 
		{
			_currentFile = event.target as File;
			_target.loadObj( _currentFile.url, 10 );
			Preferances.lastDirectory = _currentFile;
		}
		
		/**
		* Handles I/O errors that may come about when opening the currentFile.
		*/
		private function readIOErrorHandler(event:Event):void 
		{
			trace("The specified currentFile cannot be opened.");
		}
		/**
		* Handles I/O errors that may come about when writing the currentFile.
		*/
		private function writeIOErrorHandler(event:Event):void 
		{
			trace("The specified currentFile cannot be saved.");
		}
		
	}
	
}