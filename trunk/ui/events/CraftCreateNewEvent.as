﻿package ui.events {		import flash.events.Event;	public class CraftCreateNewEvent extends Event	{		public var itemList:Array;				public var levelList:Array;		public function CraftCreateNewEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)		{			super(type, bubbles, cancelable);		}									}	}