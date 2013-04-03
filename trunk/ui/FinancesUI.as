﻿package ui{		import flash.display.MovieClip;	import fl.text.TLFTextField;	import flash.events.MouseEvent;	import flash.events.Event;			import game.entity.City;	import game.Kingdom;	import game.KingdomManager;	import game.Game;		public class FinancesUI extends Panel	{						public static var SLIDER_MIN_X:int = 263;		public static var SLIDER_MAX_X:int = 363;			public static var FINANCES_PANEL:int = 2;		public static var COMMONER_TAX:int = 1;		public static var NOBLE_TAX:int = 2;		public static var TARIFF_TAX:int = 3;			public var incomeText:TLFTextField;		public var treasuryText:TLFTextField;		public var taxCommonerText:TLFTextField;		public var taxNobleText:TLFTextField;		public var taxTariffText:TLFTextField;				public var taxNobleSlider:MovieClip;		public var taxCommonerSlider:MovieClip;		public var taxTariffSlider:MovieClip;				public var confirmButton:MovieClip;			public var city:City;				public var cityUI:CityUI;						private var taxNoble:int;		private var taxCommoner:int;		private var taxTariff:int;				private var selectedTax:int;				public function FinancesUI() 		{			taxNobleSlider.addEventListener(MouseEvent.MOUSE_DOWN, sliderMouseDown);			taxNobleSlider.addEventListener(MouseEvent.MOUSE_UP, sliderMouseUp);						taxCommonerSlider.addEventListener(MouseEvent.MOUSE_DOWN, sliderMouseDown);			taxCommonerSlider.addEventListener(MouseEvent.MOUSE_UP, sliderMouseUp);						taxTariffSlider.addEventListener(MouseEvent.MOUSE_UP, sliderMouseDown);			taxTariffSlider.addEventListener(MouseEvent.MOUSE_UP, sliderMouseUp);						confirmButton.addEventListener(MouseEvent.CLICK, confirmButtonClick);		}				override public function hidePanel() : void		{			this.visible = false;		}				override public function showPanel() : void		{			this.visible = true;						setText();		}						private function setText() : void		{			var kingdom:Kingdom = KingdomManager.INSTANCE.getKingdom(city.playerId)						incomeText.text = UtilUI.FormatNum(city.getIncome());			treasuryText.text = UtilUI.FormatNum(kingdom.gold);			taxCommonerText.text = city.taxCommoner + "%";			taxNobleText.text = city.taxNoble + "%";			taxTariffText.text = city.taxTariff + "%";		}				private function sliderMouseDown(e:MouseEvent) : void		{			e.stopPropagation();						if(e.target.name == 'taxNobleSlider')			{				selectedTax = NOBLE_TAX;			}			else if(e.target.name == 'taxCommonerSlider')			{				selectedTax = COMMONER_TAX;			}			else if(e.target.name == 'taxTariffSlider')			{				selectedTax = TARIFF_TAX;			}						addEventListener(Event.ENTER_FRAME, scrollSlider);			addEventListener(MouseEvent.CLICK, sliderMouseClick);		}				private function sliderMouseUp(e:MouseEvent) : void		{			e.stopPropagation();			removeEventListener(Event.ENTER_FRAME, scrollSlider);		}				private function sliderMouseClick(e:MouseEvent) : void		{			e.stopPropagation();			removeEventListener(Event.ENTER_FRAME, scrollSlider);		}					private function scrollSlider(e:Event) : void		{			var quantity:Number;			var slider:MovieClip;			var taxText:TLFTextField;						if(selectedTax == COMMONER_TAX)			{				slider = taxCommonerSlider;				taxText = taxCommonerText;			}			else if(selectedTax == NOBLE_TAX)			{				slider = taxNobleSlider;				taxText = taxNobleText;			}			else if(selectedTax == TARIFF_TAX)			{				slider = taxTariffSlider;				taxText = taxTariffText;			}						if(this.mouseX < SLIDER_MIN_X)			{				slider.x = SLIDER_MIN_X;			}			else if(this.mouseX > SLIDER_MAX_X)			{				slider.x = SLIDER_MAX_X;			}			else			{				slider.x = this.mouseX;			}						var tax:int = (slider.x - SLIDER_MIN_X);						if(selectedTax == NOBLE_TAX)			{				taxNoble = tax;			}			else if(selectedTax == COMMONER_TAX)			{				taxCommoner = tax;			}			else if(selectedTax == TARIFF_TAX)			{				taxTariff = tax;			}						taxText.text = tax.toString() + "%";		}						private function getTaxes() : Array		{			var taxes:Array = new Array();						taxes.push({type: NOBLE_TAX, rate: taxNoble});			taxes.push({type: COMMONER_TAX, rate: taxCommoner});			taxes.push({type: TARIFF_TAX, rate: taxTariff});						return taxes;		}				private function confirmButtonClick(e:MouseEvent)		{			var parameters:Object = {cityId: city.id,									 taxes: getTaxes()};						var pEvent:ParamEvent = new ParamEvent(Game.cityUpdateTaxEvent);			pEvent.params = parameters;							Game.INSTANCE.dispatchEvent(pEvent);						}	}	}