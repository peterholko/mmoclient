﻿package {	import flash.display.DisplayObjectContainer;	import flash.utils.Dictionary;		public class Util	{        public var test:int;		public static function removeChildren(displayContainer:DisplayObjectContainer) : void		{			while (displayContainer.numChildren)				displayContainer.removeChildAt(0); 		}				public static function hasId(dictionary:Dictionary, key:int) : Boolean		{			if (dictionary[key] != null)				return true;							return false;		}					public static function unique(array:Array) : Array		{			var dict:Dictionary = new Dictionary();						for (var i:int = array.length-1; i>=0; --i)			{				var str:String = array[i] as String;				trace(str);				if (!dict[str])				{					dict[str] = true;				}				else				{					array.splice(i,1);				}			}						dict = null;						return array;		}	}	}