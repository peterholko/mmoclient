﻿package game.entity
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	
	import game.Game;
	import game.map.Tile;
		
	public class Entity extends Sprite
	{
		public static var ARMY:int = 1;
		public static var CITY:int = 2;
		
		public var id:int;
		public var playerId:int;
		public var state:int;
		public var gameX:int;
		public var gameY:int;	
		public var type:int;
		public var tile:Tile;

		protected var image:Bitmap = null;	
	
		public function Entity() : void
		{
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClick);
			addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		public function initialize() : void
		{
		}
		
		public function update() : void
		{
			x = gameX * Tile.WIDTH;
			y = gameY * Tile.HEIGHT;				
		}
		
		public function getImage() : Bitmap
		{
			return image;
		}
		
		public function isPlayers() : Boolean
		{
			return playerId == Game.INSTANCE.player.id;
		}
		
		protected function mouseClick(e:Event) : void
		{
		}
		
		protected function mouseDoubleClick(e:Event) : void
		{
		}
	}
}