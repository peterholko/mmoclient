﻿package net.packet{	public class InfoCity implements IPacket	{		public var id:int;		public var name:String;		public var taxCommoner:int;		public var taxNoble:int;		public var taxTariff:int;		public var buildings:Array		public var units/*Unit*/:Array;		public var claims:Array;		public var improvements:Array;		public var assignments:Array;		public var items:Array;		public var populations:Array;		public var contracts:Array;				public function InfoCity() : void		{				}	}	}