﻿package ui {		import flash.display.MovieClip;	import fl.text.TLFTextField;	import flash.display.Bitmap;	import flash.display.BitmapData;			public class SelectedBlockCity extends MovieClip {				public var cityName:TLFTextField;		public var kingdomName:TLFTextField;				public function SelectedBlockCity() {			// constructor code		}				public function setImage(bitmapData:BitmapData) : void		{					var image:Bitmap = new Bitmap(bitmapData);			image.x = 1;			image.y = 1;						addChild(image);					}			}	}