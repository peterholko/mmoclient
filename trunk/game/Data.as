﻿package game{	public class Data 	{		public var farmOne:ImprovementType;		public var farmTwo:ImprovementType;		public var farmThree:ImprovementType;		public var farmFour:ImprovementType;		public var farmFive:ImprovementType;				public var trapperOne:ImprovementType;		public var trapperTwo:ImprovementType;		public var trapperThree:ImprovementType;		public var trapperFour:ImprovementType;		public var trapperFive:ImprovementType;		public var lumbermillOne:ImprovementType;		public var lumbermillTwo:ImprovementType;		public var lumbermillThree:ImprovementType;		public var lumbermillFour:ImprovementType;		public var lumbermillFive:ImprovementType;				public var mineOne:ImprovementType;		public var mineTwo:ImprovementType;		public var mineThree:ImprovementType;		public var mineFour:ImprovementType;		public var mineFive:ImprovementType;				public var quarryOne:ImprovementType;		public var quarryTwo:ImprovementType;		public var quarryThree:ImprovementType;		public var quarryFour:ImprovementType;		public var quarryFive:ImprovementType;		public var barracksOne:BuildingType;				public var bristleSpinePig:ItemType;		public var chisotanLeaf:ItemType;						public function Data() 		{			setImpType(farmOne, 1, ImprovementType.FARM, 1, "Tiny Farm");			setImpType(farmTwo, 2, ImprovementType.FARM, 2, "Small Farm");			setImpType(farmThree, 3, ImprovementType.FARM, 3, "Farm");			setImpType(farmFour, 4, ImprovementType.FARM, 4, "Large Farm");			setImpType(farmFive, 5, ImprovementType.FARM, 5, "Huge Farm");						setImpType(trapperOne, 6, ImprovementType.TRAPPER, 1, "Tiny Trapper");			setImpType(trapperTwo, 7, ImprovementType.TRAPPER, 2, "Small Trapper");			setImpType(trapperThree, 8, ImprovementType.TRAPPER, 3, "Trapper");			setImpType(trapperFour, 9, ImprovementType.TRAPPER, 4, "Large Trapper");			setImpType(trapperFive, 10, ImprovementType.TRAPPER, 5, "Huge Trapper");											}				public function setImpType(improvementType:ImprovementType, id:int, category:int, 									level:int, name:String) : void		{			improvementType = new ImprovementType();			improvementType.id = id;			improvementType.category = category;			improvementType.level = level;			improvementType.name = name;		}				public function setItemType(itemType:ItemType, id:int, category:int, name:String, 									buildingReq:int, improvementReq:int) : void		{			itemType = new ItemType();			itemType.id = id;			itemType.category = category;			itemType.name = name;			itemType.buildingReq = buildingReq;			itemType.improvementReq = improvementReq;		}					public function setBuildingType(buildingType:BuildingType, id:int, 										level:int, name:String) : void		{			buildingType = new BuildingType();			buildingType.id = id;			buildingType.level = level;			buildingType.name = name;		}	}	}