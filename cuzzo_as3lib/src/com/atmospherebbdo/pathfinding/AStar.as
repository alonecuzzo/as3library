package com.atmospherebbdo.pathfinding 
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;	
	
	[Event(name="pathFound", type="com.atmospherebbdo.pathfinding.PathfindingEvent")]
	[Event(name="pathError", type="com.atmospherebbdo.pathfinding.PathfindingEvent")]
	[Event(name="cycleComplete", type="com.atmospherebbdo.pathfinding.PathfindingEvent")]
	
	/**
	 * AStar class adapted from original from canazza.co.uk. This thing needs
	 * some serious love, but it's a good start.
	 */
	public class AStar extends EventDispatcher
	{
		public var Path:Array = [];
		public var CutCorners:Boolean = false;
		
		private var OpenList:Array;
		private var ClosedList:Array = [];
		private var Grid:Array = new [];
		private var CurrentNode:Object;
		private var StartNode:Object;
		private var EndNode:Object;
		private var Walls:Array = new [];
		private var msPerCycle:int = 50;
		private var sqPerCycle:int = 1;
		private var gWidth:int;
		private var gHeight:int;
		private var timeout:uint;
		private var startTime:Date;
		private var endTime:Date;
		/////////////////////////////////////////////////////////////////////////////////
		//////////////////////////Actionscript 3.0 Events list///////////////////////////
		//
		//	Example:
		//		var pathSearcher:AStar = new AStar(10,10);
		//		pathSearcher.addEventListener(PathFindingEvent.PATH_FOUND, onPathFound);
		//		pathSearcher.addEventListener(PathFindingEvent.PATH_ERROR, onPathError);
		//		pathSearcher.addEventListener(PathFindingEvent.CYCLE_COMPLETE, onCycleComplete);
		//
		/////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////
		public function AStar(w:Number,h:Number) 
		{
			gWidth = w;
			gHeight = h;
			for(var i:uint = 0;i < w; i++) 
			{
				Grid[i] = new Array();
				ClosedList[i] = new Array;
				for(var j:uint = 0;j < h; j++) 
				{
					Grid[i][j] = new AStarNode(i, j, null);
					ClosedList[i][j] = false;
				}
			}
			for(i = 0;i < w; i++) 
			{
				Walls[i] = new Array();
				for(j = 0;j < h; j++)
				{
					Walls[i][j] = false;
				}
			}
		}

		public function getScores(px:uint,py:uint) :*
		{
			if(px < 0) 
			{
				return false;
			}
			if(px >= gWidth) 
			{
				return false;
			}
			if(py < 0) 
			{
				return false;
			}
			if(py >= gHeight) 
			{
				return false;
			}
			return "Score at " + px + "," + py + " \n\t F = " + Grid[px][py].F() + "\n\t G = " + Grid[px][py].G + "\n\t H = " + Grid[px][py].H;
		}

		public function AddWalls(pWalls:Array) :void
		{
			var obj:Object;
			while(obj = pWalls.pop()) 
			{
				if(obj.x < 0) 
				{
					continue;
				}
				if(obj.x > gWidth) 
				{
					continue;
				}
				if(obj.y < 0) 
				{
					continue;
				}
				if(obj.y > gHeight) 
				{
					continue;
				}
				
				Walls[obj.x][obj.y] = true;
			}
		}

		public function clearWalls() :void
		{
			for(var i:uint = 0;i < gWidth; i++) 
			{
				Walls[i] = new Array();
				for(var j:uint = 0;j < gHeight; j++)
				{
					Walls[i][j] = false;
				}
			}
		}

		public function Draw(scale:int):MovieClip 
		{
			var Canvas:MovieClip = new MovieClip();
			Canvas.graphics.beginFill(0x888888);
			Canvas.graphics.drawRect(0, 0, gWidth * scale, gHeight * scale);
			Canvas.graphics.endFill();
			Canvas.graphics.lineStyle(0, 0xFF0000, 0.2);
			for(var i:uint = 0;i < Grid.length; i++) 
			{
				for(var j:uint = 0;j < Grid[i].length; j++) 
				{
					if(Walls[i][j] == true) Canvas.graphics.beginFill(0x000000);
					if(ClosedList[i][j] == true) Canvas.graphics.beginFill(0xFF0000, 0.5);
					Canvas.graphics.drawRect(i * scale, j * scale, scale, scale);
					Canvas.graphics.endFill();
				}
			}
			try 
			{
				for(i = 0;i < OpenList.length; i++) 
				{
					Canvas.graphics.beginFill(0x0000FF, 0.4);
					Canvas.graphics.drawRect(OpenList[i].x * scale, OpenList[i].y * scale, scale, scale);
					Canvas.graphics.endFill();
				}
			} 
			catch(a:Error) 
			{ 
				; 
			}
			if(Path[0]) 
			{
				Canvas.graphics.lineStyle(3, 0x88FF00);
				Canvas.graphics.moveTo(Path[0].x * scale + scale / 2, Path[0].y * scale + scale / 2);
				for(i = 0;i < Path.length; i++) 
				{
					Canvas.graphics.lineTo(Path[i].x * scale + scale / 2, Path[i].y * scale + scale / 2);
				}
			}
			return Canvas;
		}

		public function Stop() :void
		{
			trace("TIMEOUT " + timeout);
			clearTimeout(timeout);
			for(var i:uint = 0;i < gWidth; i++) 
			{
				Grid[i] = null;
				Grid[i] = new Array();
				ClosedList[i] = null ;
				ClosedList[i] = new Array();
				for(var j:uint = 0;j < gHeight; j++) 
				{
					Grid[i][j] = null; 
					Grid[i][j] = new AStarNode(i, j, null);
					ClosedList[i][j] = false;
				}
			}
			
			endTime = null;
			startTime = null;
			Path = new Array();
			OpenList = new Array();
		}

		public function getLastCount() :Number
		{
			endTime = new Date();
			try 
			{
				return (endTime.getTime() - startTime.getTime());
			} 
			catch(e:Error) 
			{ 
				trace(e); 
			}
			return 0;
		}

		public function Start(Start:Object,End:Object) :Boolean
		{
			StartNode = Start;
			EndNode = End;
			Stop();
			if(Walls[EndNode.x][EndNode.y] == true) 
			{ 
				dispatchEvent(new PathFindingEvent(PathFindingEvent.PATH_ERROR));
				return false;
			}
			Grid[StartNode.x][StartNode.y].make(null, End);
			OpenList = new Array(Grid[StartNode.x][StartNode.y]);
			startTime = new Date();
			
			newCycle();
			return true;
		}

		private function newCycle() :Boolean
		{
			for(var i:int = 0;i < sqPerCycle; i++) 
			{
				//////////////////////////////////
				//  ASTAR SEARCH BEGINS HERE	 //
				//////////////////////////////////
				CurrentNode = getLowestF();
				
				if(!CurrentNode) return false;
				try 
				{ 
					OpenList.splice(CurrentNode.Index, 1);
					ClosedList[CurrentNode.x][CurrentNode.y] = true;
				} catch(transferError:Error) 
				{ 
					trace("Error transferring Current Node: " + CurrentNode.x + "," + CurrentNode.y); 
				}
				
				try 
				{
					for(var adjX:int = CurrentNode.x - 1;adjX < CurrentNode.x + 2; adjX++) 
					{
						if(adjX < 0) continue;
						if(adjX > gWidth - 1) continue;
						for(var adjY:int = CurrentNode.y - 1;adjY < CurrentNode.y + 2; adjY++)  
						{
							try 
							{
								if(adjY < 0) continue;
								if(adjY > gHeight - 1) continue;
								try 
								{
									if(Walls[adjX][adjY] == true)
									{
										continue;
									}
									if(ClosedList[adjX][adjY] != false) 
									{
										continue;
									}
								} 
									catch(eliminationError:Error) 
								{ 
									trace("Error eliminating closed node:" + adjX + "," + adjY); 
								}
								if(Grid[adjX][adjY].Parent) 
								{ 
									if(Grid[adjX][adjY].G >= Grid[adjX][adjY].cG(CurrentNode)) 
									{
										Grid[adjX][adjY].make(Grid[CurrentNode.x][CurrentNode.y], EndNode);
									}
									continue;
								}
						
								Grid[adjX][adjY].make(Grid[CurrentNode.x][CurrentNode.y], EndNode);
								if(CutCorners == false) 
								{
									if(Math.abs(Grid[adjX][adjY].G - Grid[CurrentNode.x][CurrentNode.y].G) == 14) 
									{
										Grid[adjX][adjY].Parent = null;
										if(Walls[CurrentNode.x][adjY] == true) 
										{
											continue;
										}
										if(Walls[adjX][CurrentNode.y] == true) 
										{
											continue;
										}
										Grid[adjX][adjY].Parent = Grid[CurrentNode.x][CurrentNode.y];
									}
								}
								OpenList.push(Grid[adjX][adjY]);
							} catch(yLoopError:Error) 
							{ 
								trace("Error in Y Loop:" + CurrentNode.x + "," + CurrentNode.y + yLoopError); 
							}
						}
					}
				} catch(e:Error) 
				{ 
					trace("Error in main loop"); 
				}
				  //////////////////////////////////
				 //	ASTAR CYCLE ENDS HERE		 //
				//////////////////////////////////
			}
			dispatchEvent(new PathFindingEvent(PathFindingEvent.CYCLE_COMPLETE));
			timeout = setTimeout(newCycle, msPerCycle);
			return true;
		}

		private function getLowestF() :*
		{
			var lowestF:Object = {F:-1};
			if(OpenList.length == 0) 
			{
				dispatchEvent(new PathFindingEvent(PathFindingEvent.PATH_ERROR));
				return false;
			}
			for(var i:uint = 0;i < OpenList.length; i++) 
			{
				if(lowestF.F == -1) 
				{
					lowestF = {index:i, x:OpenList[i].x, y:OpenList[i].y, F:OpenList[i].F()};
					continue;
				}
				if(OpenList[i].F() < lowestF.F) 
				{
					lowestF = {Index:i, x:OpenList[i].x, y:OpenList[i].y, F:OpenList[i].F()};
				}
			}
			if(lowestF.x == EndNode.x)
			{
				if(lowestF.y == EndNode.y) 
				{
					GetPath();
					dispatchEvent(new PathFindingEvent(PathFindingEvent.PATH_FOUND));
					return false;
				}
			}
			return lowestF;
		}

		private function GetPath() :void
		{
			var Node:Object = Grid[EndNode.x][EndNode.y];
			do 
			{
				Path.unshift(Node);
				Node = Node.Parent;
			} while(Node != null);
		}

		public function setPriorities(bx:int,ms:int) :void
		{
			msPerCycle = ms;
			sqPerCycle = bx;
		}
	}
}

class AStarNode 
{ 
	public var x:int = 0;
	public var y:int = 0;
	public var G:int = 0;
	public var H:int = 0;
	public var Parent:AStarNode;

	public function AStarNode(px:int,py:int,pParent:AStarNode) 
	{
		x = px;
		y = py;
		Parent = pParent;
	}

	public function F() :int
	{
		return G + H;
	}

	public function make(pParent:AStarNode,End:Object) :void
	{
		Parent = pParent;
		fH(End);
		fG();
	}

	public function cG(node:Object) :int
	{
		if(x == node.x) 
		{ 
			return 10 + node.G; 
		}
		if(y == node.y) 
		{ 
			return 10 + node.G; 
		}
		return 14 + node.G;
	}

	public function fG() :int
	{
		if(!Parent) return 0;
		if(x == Parent.x) 
		{ 
			G = 10 + Parent.G; 
			return G; 
		}
		if(y == Parent.y) 
		{ 
			G = 10 + Parent.G; 
			return G; 
		}
		G = 14 + Parent.G;
		return G;
	}

	public function fH(target:Object) :int
	{
		H = (Math.abs(x - target.x) + Math.abs(y - target.y)) * 14;
		return H;
	}
}
