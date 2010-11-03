package com.rokkan.programs.characteranimator.controls 
{
	import com.rokkan.programs.characteranimator.shared.Preferances;
	import fl.controls.List;
	import fl.controls.TileList;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.ui.ContextMenuItem;
	import gs.TweenLite;
	import flash.filesystem.*;
	import flash.events.*;
	import flash.system.Capabilities;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class FileDropDown extends Sprite 
	{
		// inherent vars
		public var list_mc:List;
		public var fileMenuTitle_mc:MovieClip;
		public var back_mc:MovieClip;
		
		// The currentFile opened (and saved) by the application
		private var currentFile:File;
		
		// The FileStream object used for reading and writing the currentFile
		private var stream:FileStream = new FileStream();
		
		 // The default directory
		private var defaultDirectory:File;
		
		// Whether the text data has changed (and should be saved)
		public var dataChanged:Boolean = false; 
		
		public function FileDropDown() 
		{
			
		}
		
		public function init() {
			list_mc.addItem( { label:"New Animation", data:"NewAnimation" } );
			list_mc.addItem( { label:"Open Animation", data:"OpenAnimation" } );
			list_mc.addItem( { label:"Save Animation", data:"SaveAnimation" } );
			list_mc.addItem( { label:"--------------", data:"" } );
			list_mc.addItem( { label:"New Model", data:"NewModel" } );
			list_mc.addItem( { label:"Open Model", data:"OpenModel" } );
			list_mc.addItem( { label:"Save Model", data:"SaveModel" } );
			
			list_mc.height = list_mc.rowHeight * list_mc.rowCount;
			list_mc.addEventListener("change", fileChange, false, 0, true);
			list_mc.visible = false;
			
			this.addEventListener( MouseEvent.MOUSE_DOWN, handleDown, false, 0, true);
			this.addEventListener( MouseEvent.ROLL_OUT, handleOut, false, 0, true);
		}
		
		private function fileChange( e:Event = null) {
			var selectedLabel:String = list_mc.selectedItem.data;
			
			switch( selectedLabel )
			{
				case "NewAnimation":
					parent["reset"]();
					break;
				case "OpenAnimation":
					animOpenFile();
					break;
				case "SaveAnimation":
					animSaveAs();
					break;
				case "NewModel":
					parent["resetModel"]();
					break;
				case "OpenModel":
					modelOpenFile();
					break;
				case "SaveModel":
					modelSaveAs();
					break;
				default:
					trace("Unkown Input");
					break;
			}
		}
		
		private function handleDown( e:MouseEvent = null ) {
			list_mc.visible = true;
			TweenLite.to( back_mc, 0, { tint:0x0000FF } );
			TweenLite.to( fileMenuTitle_mc, 0, { tint:0xFFFFFF, overwrite:false } );
		}
		
		private function handleOut( e:MouseEvent = null ) {
			TweenLite.to( back_mc, 0, { tint:0xEAEAEA } );
			TweenLite.to( fileMenuTitle_mc, 0, { tint:0x000000, overwrite:false } );
			list_mc.visible = false;
			list_mc.clearSelection();
		}
		
		/************************
		 * Model Save/Load Methods
		 * *********************/
		private function modelOpenFile() {
			var fileChooser:File = fileChooser = Preferances.lastDirectory;
			var fileFilter = new FileFilter("Model File", "*.xml");
			fileChooser.browseForOpen("Open", [fileFilter]);
			fileChooser.addEventListener(Event.SELECT, modelFileOpenSelected);
		}
		
		private function modelFileOpenSelected(event:Event):void 
		{
			parent["resetModel"]();
			currentFile = event.target as File;
			stream = new FileStream();
			stream.openAsync(currentFile, FileMode.READ);
			stream.addEventListener(Event.COMPLETE, modelFileReadHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, readIOErrorHandler);
			dataChanged = false;
			currentFile.removeEventListener(Event.SELECT, modelFileOpenSelected);
		}
		
		private function modelFileReadHandler(event:Event):void 
		{
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			var lineEndPattern:RegExp = new RegExp(File.lineEnding, "g");
			str = str.replace(lineEndPattern, "\n");
			
			var convertFile:XML;
			
			try {
				convertFile = new XML(str);
			}catch (e:Error) {
				trace("Error Reading File");
			}
			
			parent["modelFromXML"]( convertFile );
			
			stream.close();
		}
		 
		private function modelSaveAs(event:MouseEvent = null):void {
			var fileChooser:File = Preferances.lastDirectory;;
			fileChooser.browseForSave("Save Model As");
			fileChooser.addEventListener(Event.SELECT, modelSaveAsFileSelected);
		}
		
		private function modelSaveAsFileSelected(event:Event):void 
		{
			currentFile = event.target as File;
			
			if(!currentFile.extension || currentFile.extension != "xml"){
				trace("no extension");
				currentFile.nativePath += ".xml";
			}
			
			modelSaveFile();
			dataChanged = false;
			currentFile.removeEventListener(Event.SELECT, animSaveAsFileSelected);
		}
		
		private function modelSaveFile(event:MouseEvent = null):void 
		{
			if (stream != null)	{
				stream.close();
			}
			stream = new FileStream();
			stream.openAsync(currentFile, FileMode.WRITE);
			stream.addEventListener(IOErrorEvent.IO_ERROR, writeIOErrorHandler);
			var str:String = parent["modelToXML"]();
			str = str.replace(/\r/g, "\n");
			str = str.replace(/\n/g, File.lineEnding);
			stream.writeUTFBytes(str);
			stream.close();
			dataChanged = false;
			
			Preferances.lastDirectory = currentFile;
		}
		
		/************************
		 * Animation Save/Load Methods
		 * *********************/		
		private function animSaveFile(event:MouseEvent = null):void 
		{
			if (currentFile) {
				if (stream != null)	{
					stream.close();
				}
				stream = new FileStream();
				stream.openAsync(currentFile, FileMode.WRITE);
				stream.addEventListener(IOErrorEvent.IO_ERROR, writeIOErrorHandler);
				var str:String = parent["toXML"]();
				str = str.replace(/\r/g, "\n");
				str = str.replace(/\n/g, File.lineEnding);
				trace("animSaveFile str:" + str);
				stream.writeUTFBytes(str);
				stream.close();
				dataChanged = false;
			} else {
				animSaveAs();
			}
			
			Preferances.lastDirectory = currentFile;
		}
		
		public function animSaveAs(event:MouseEvent = null):void 
		{
			trace("Saving as");
			var fileChooser:File;
			if (currentFile){
				fileChooser = currentFile;
			}else{
				fileChooser = Preferances.lastDirectory;
			}
			fileChooser.browseForSave("Save Animation As");
			fileChooser.addEventListener(Event.SELECT, animSaveAsFileSelected);
		}
		
		private function animSaveAsFileSelected(event:Event):void 
		{
			currentFile = event.target as File;
			
			if(!currentFile.extension || currentFile.extension != "xml"){
				trace("no extension");
				currentFile.nativePath += ".xml";
			}
			
			animSaveFile();
			dataChanged = false;
			currentFile.removeEventListener(Event.SELECT, animSaveAsFileSelected);
		}
		
		private function animOpenFile() {
			var fileChooser:File;
			if (currentFile){
				fileChooser = currentFile;
			}else{
				fileChooser = Preferances.lastDirectory;
			}
			var fileFilter = new FileFilter("Animation File", "*.xml");
			fileChooser.browseForOpen("Open", [fileFilter]);
			fileChooser.addEventListener(Event.SELECT, animFileOpenSelected);
		}
		private function animFileOpenSelected(event:Event):void 
		{
			parent["reset"]();
			currentFile = event.target as File;
			stream = new FileStream();
			stream.openAsync(currentFile, FileMode.READ);
			stream.addEventListener(Event.COMPLETE, animFileReadHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, readIOErrorHandler);
			dataChanged = false;
			currentFile.removeEventListener(Event.SELECT, animFileOpenSelected);
		}
		private function animFileReadHandler(event:Event):void 
		{
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			var lineEndPattern:RegExp = new RegExp(File.lineEnding, "g");
			str = str.replace(lineEndPattern, "\n");
			
			var convertFile:XML;
			
			try {
				convertFile = new XML(str);
			}catch (e:Error) {
				trace("Error Reading File");
			}
			
			parent["fromXML"]( convertFile );
			
			stream.close();
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