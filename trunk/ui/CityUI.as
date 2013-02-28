﻿package ui {	import flash.utils.getQualifiedClassName		import flash.display.MovieClip;	import flash.events.MouseEvent;	import flash.display.Bitmap;	import flash.display.DisplayObject;	import flash.text.TextField;	import fl.text.TLFTextField;		import game.entity.City;	import game.entity.Improvement;	import game.Game;	import game.map.MapObjectType;	import game.Building;	import game.Assignment;	import game.Population;	import game.Item;	import game.entity.Entity;	import game.Contract;		import ui.events.MainUIEvents;	import ui.events.ShowCityUIEvent;	import game.KingdomManager;	import ui.events.CityUIEvents;	import ui.events.CraftCreateNewEvent;	import flash.ui.Mouse;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.utils.getTimer;	import ui.events.TrainCreateNewEvent;	import ui.events.GameEvents;	import ui.events.PopDragDropEvent;			public class CityUI extends MovieClip 	{				public var ICON_SPACER:int = 3;				public var IMPROVEMENTS_INFO_Y_TOP:int = 142;		public var IMPROVEMENTS_INFO_Y_BOTTOM:int = 367;				public var BUILDINGS_START_X:int = 3;		public var BUILDINGS_START_Y:int = 145;				public var IMPROVEMENTS_START_X:int = 3;		public var IMPROVEMENTS_START_Y:int = 163;						public var BUILDINGS_INFO:String = "buildings";		public var IMPROVEMENTS_INFO:String = "improvements";						public var closeButton:MovieClip;									public var inventoryUI:InventoryUI;		public var financesUI:FinancesUI;		public var populationUI:PopulationUI;		public var throneUI:ThroneUI;			public var unitsUI:UnitsUI;						public var throneText:TLFTextField;		public var populationText:TLFTextField;		public var financesText:TLFTextField;		public var inventoryText:TLFTextField;				public var unitsText:TLFTextField;				public var buildingsInfo:MovieClip;		public var improvementsInfo:MovieClip;		public var structurePanel:MovieClip;				public var queueMarketUI:QueueMarketUI;		public var buildingDetailCard:BuildingDetailCard;				public var unitBuilder:UnitBuilder;		public var itemBuilder:ItemBuilder;				public var trainContract:TrainContract;		public var buildContract:BuildContract;		public var craftContract:CraftContract;				public var armyOverviewUI:ArmyOverviewUI;			public var popText:TLFTextField;		public var cityNameText:TLFTextField;		public var incomeText:TLFTextField;		public var cityLongNameText:TLFTextField;		public var empireKingdomNameText:TLFTextField;		public var cityRatingText:TLFTextField;				public var assignPopUI:AssignPopUI;		public var disableBackground:MovieClip;				private var city:City;				private var improvementIcons:Array;		private var buildingsIcons:Array;				private var previousPanel:Panel = null;		private var activatedPanel:Panel = null;				private var activatedInfoColumn:String = BUILDINGS_INFO;				private var timer:Timer = new Timer(250, 1);		private var startTime:int;				private var selectedIconBuilding:IconBuilding;		private var selectedIconImprovement:IconEntity;				private var userPanelClicked:Boolean = false;			public function CityUI() 		{						improvementIcons = new Array();			buildingsIcons = new Array();									//this.addEventListener(MouseEvent.CLICK, mouseClick);			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);							closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick);					}				public function init() : void		{			this.visible = false;							activatedInfoColumn = BUILDINGS_INFO;						hidePanels();			hidePopUps();						throneText.addEventListener(MouseEvent.CLICK, throneTextClick);			populationText.addEventListener(MouseEvent.CLICK, populationTextClick);			financesText.addEventListener(MouseEvent.CLICK, financesTextClick);			inventoryText.addEventListener(MouseEvent.CLICK, inventoryTextClick);			unitsText.addEventListener(MouseEvent.CLICK, unitsTextClick);						buildingsInfo.addEventListener(MouseEvent.CLICK, buildingsInfoClick);			improvementsInfo.addEventListener(MouseEvent.CLICK, improvementsInfoClick);						assignPopUI.confirmButton.addEventListener(MouseEvent.CLICK, assignPopConfirmClick);			assignPopUI.cancelButton.addEventListener(MouseEvent.CLICK, assignPopCancelClick);						buildingDetailCard.closeButton.addEventListener(MouseEvent.CLICK, buildingDetailCloseClick);						UIEventDispatcher.INSTANCE.addEventListener(MainUIEvents.FormClickEvent, formClick);			UIEventDispatcher.INSTANCE.addEventListener(MainUIEvents.TrainClickEvent, trainClick);			UIEventDispatcher.INSTANCE.addEventListener(MainUIEvents.CityBuildClickEvent, buildClick);			UIEventDispatcher.INSTANCE.addEventListener(MainUIEvents.CityCraftClickEvent, craftClick);			UIEventDispatcher.INSTANCE.addEventListener(MainUIEvents.ShowCityUIEvent, showCityUI);			UIEventDispatcher.INSTANCE.addEventListener(CityUIEvents.CraftCreateNewEvent, craftCreateNewClick);			UIEventDispatcher.INSTANCE.addEventListener(CityUIEvents.TrainCreateNewEvent, trainCreateNewClick);			UIEventDispatcher.INSTANCE.addEventListener(CityUIEvents.PopDragDropEvent, populationDragDrop);						UIEventDispatcher.INSTANCE.addEventListener(GameEvents.SuccessTransferItem, itemTransfered);			UIEventDispatcher.INSTANCE.addEventListener(GameEvents.SuccessTransferUnit, unitTransfered);						UIEventDispatcher.INSTANCE.addEventListener(GameEvents.PerceptionUpdate, perceptionUpdate);		}				public function setCity(city:City) : void		{			this.city = city;						throneUI.city = city;			throneUI.cityUI = this;						financesUI.city = city;			financesUI.cityUI = this;						inventoryUI.city = city;			inventoryUI.cityUI = this;						populationUI.city = city;			populationUI.cityUI = this;						unitsUI.city = city;			unitsUI.cityUI = this;			queueMarketUI.city = city;			queueMarketUI.init();						buildingDetailCard.city = city;			buildingDetailCard.cityUI = this;						buildContract.city = city;			craftContract.city = city;			trainContract.city = city;						armyOverviewUI.city = city;		}								public function showPanel() : void		{						this.parent.setChildIndex(this, this.parent.numChildren - 1);										this.visible = true;								trace("CityUI showPanel previousPanel: " + previousPanel + " activatedPanel: " + activatedPanel);					if(previousPanel == null)			{				previousPanel = throneUI;				activatedPanel = throneUI;				throneUI.showPanel();													}			else			{				previousPanel.hidePanel();				activatedPanel.showPanel();			}										showActivatedInfoPanel();						if(!userPanelClicked)			{				hidePopUps();			}						if(activatedInfoColumn == BUILDINGS_INFO)			{				setBuildings();			}			else			{				setImprovements();			}						userPanelClicked = false;						setPopUpsDisplayIndex();			setCityText();		}						public function getCityId() : int		{			return city.id;		}				public function populationDragDrop(e:PopDragDropEvent) : void		{			var popDropTarget:DisplayObject = e.popDropTarget;			var caste:int = e.caste;			var race:int = e.race;						for(var i:int = 0; i < buildingsIcons.length; i++)			{				var iconBuilding:IconBuilding = IconBuilding(buildingsIcons[i]);								if(iconBuilding.contains(popDropTarget))				{					trace("Set assign pop visible")					var type:int = iconBuilding.building.type;					var taskId:int = iconBuilding.building.id;					var buildingName:String = Building.getNameByType(type);													showAssignPopUp(Entity.BUILDING, taskId, buildingName, caste, race, 100);					break;				}			}						for(var i:int = 0; i < improvementIcons.length; i++)			{				var iconEntity:IconEntity = IconEntity(improvementIcons[i]);								trace("popDropTarget: " + popDropTarget);				if(iconEntity.contains(popDropTarget))				{					var improvement:Improvement = Improvement(iconEntity.entity);										var type:int = improvement.subType;					var taskId:int = improvement.id;					var improvementName:String = improvement.getName();										showAssignPopUp(Entity.IMPROVEMENT, taskId, improvementName, caste, race, 100);					break;				}			}		}				public function removeAssignment(assignmentId:int) : void		{			var assignment:Assignment = new Assignment();						assignment.id = assignmentId;			assignment.cityId = city.id;						var pEvent:ParamEvent = new ParamEvent(Game.removeTaskEvent);			pEvent.params = assignment;							Game.INSTANCE.dispatchEvent(pEvent);				}				private function setCityText() : void		{			cityNameText.text = city.cityName;			empireKingdomNameText.text = KingdomManager.INSTANCE.getKingdom(city.playerId).name;					cityLongNameText.text = city.cityName;			popText.text = UtilUI.FormatNum(city.getTotalPop());			incomeText.text = UtilUI.FormatNum(city.getIncome());		}						private function assignTask(caste:int, race:int, amount:int, targetId:int, targetType:int): void		{			var assignment:Assignment = new Assignment();						assignment.cityId = city.id;			assignment.caste = caste;			assignment.race = race;			assignment.amount = amount;						assignment.targetId = targetId;			assignment.targetType = targetType;					var pEvent:ParamEvent = new ParamEvent(Game.assignTaskEvent);			pEvent.params = assignment;							Game.INSTANCE.dispatchEvent(pEvent);								}				private function cityCraftItem(itemType:int, itemSize:int) : void		{			var parameters:Object = {cityId: city.id,									 itemType: itemType,									 itemSize: itemSize};						var pEvent:ParamEvent = new ParamEvent(Game.cityCraftItemEvent);			pEvent.params = parameters;							Game.INSTANCE.dispatchEvent(pEvent);								}				private function assignPopConfirmClick(e:MouseEvent) : void		{			hidePopUps();						var amount:int = parseInt(assignPopUI.popInputText.text)						if(amount == NaN)				amount = 0;						assignTask(assignPopUI.caste,					   assignPopUI.race,					   amount,					   assignPopUI.taskId,					   assignPopUI.taskType);					}				private function assignPopCancelClick(e:MouseEvent) : void		{			hidePopUps();		}						private function throneTextClick(e:MouseEvent) : void		{						userPanelClicked = true;			previousPanel = activatedPanel;			activatedPanel = throneUI;						Game.INSTANCE.requestInfo(MapObjectType.CITY, city.id);		}				private function populationTextClick(e:MouseEvent) : void		{			userPanelClicked = true;			previousPanel = activatedPanel;						activatedPanel = populationUI;						Game.INSTANCE.requestInfo(MapObjectType.CITY, city.id);		}				private function unitsTextClick(e:MouseEvent) : void		{			userPanelClicked = true;			previousPanel = activatedPanel;					activatedPanel = unitsUI;						Game.INSTANCE.requestInfo(MapObjectType.CITY, city.id);		}						private function financesTextClick(e:MouseEvent) : void		{			userPanelClicked = true;			previousPanel = activatedPanel;					activatedPanel = financesUI;						Game.INSTANCE.requestInfo(MapObjectType.CITY, city.id);		}				private function inventoryTextClick(e:MouseEvent) : void		{			userPanelClicked = true;			previousPanel = activatedPanel;													activatedPanel = inventoryUI;						Game.INSTANCE.requestInfo(MapObjectType.CITY, city.id);		}								private function buildingsInfoClick(e:MouseEvent) : void		{			setBuildings();		}				private function setBuildings() : void		{			clearInfoColumn();			bottomImprovementsInfo();						//Setup building icons			setBuildingIcons();			activatedInfoColumn = BUILDINGS_INFO;					}				private function improvementsInfoClick(e:MouseEvent) : void		{			setImprovements();		}				private function setImprovements() : void		{			//Handle UI navigation			clearInfoColumn();			topImprovementsInfo();						//Setup improvement icons			setImprovementIcons();			activatedInfoColumn = IMPROVEMENTS_INFO;					}				private function setImprovementIcons() : void		{			for (var i:int = 0; i < city.improvements.length; i++)			{				var improvement:Improvement = Improvement(city.improvements[i]);												var iconEntity:IconEntity = new IconEntity();				iconEntity.setEntity(improvement);				iconEntity.copyImage(48, 48);				iconEntity.x = IMPROVEMENTS_START_X + ICON_SPACER + (i % 4) * (iconEntity.width + ICON_SPACER);				iconEntity.y = IMPROVEMENTS_START_Y + int(i / 4) * (iconEntity.height + ICON_SPACER);				iconEntity.anchorX = iconEntity.x;				iconEntity.anchorY = iconEntity.y;				iconEntity.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownImprovement);				iconEntity.addEventListener(MouseEvent.MOUSE_UP, mouseUpImprovement);							improvement.icon = iconEntity;				improvementIcons.push(iconEntity);								addChild(iconEntity);			}					}					private function setBuildingIcons() : void		{			for(var i:int = 0; i < city.buildings.length; i++)			{				var building:Building = Building(city.buildings[i]);				var iconBuilding:IconBuilding = new IconBuilding();				iconBuilding.setBuilding(building)				iconBuilding.x = BUILDINGS_START_X + ICON_SPACER + (i % 4) * (iconBuilding.width + ICON_SPACER);				iconBuilding.y = BUILDINGS_START_Y + int(i / 4) * (iconBuilding.height + ICON_SPACER);				iconBuilding.anchorX = iconBuilding.x;				iconBuilding.anchorY = iconBuilding.y;								iconBuilding.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownBuilding);				iconBuilding.addEventListener(MouseEvent.MOUSE_UP, mouseUpBuilding);								buildingsIcons.push(iconBuilding);								addChild(iconBuilding);			}		}				private function buildingClick(iconBuilding:IconBuilding) : void		{			trace("buildingClick");						var buildingId:int = iconBuilding.building.id;			var assignments:Array = city.getAssignmentsByTarget(buildingId, Entity.BUILDING);						var contract:Contract = city.getContract(buildingId, Entity.BUILDING);						buildingDetailCard.parent.setChildIndex(buildingDetailCard, buildingDetailCard.parent.numChildren - 1);							buildingDetailCard.visible = true;			buildingDetailCard.objectNameText.text = iconBuilding.building.getName();			buildingDetailCard.objectFullNameText.text = iconBuilding.building.getName();			buildingDetailCard.objectNameLevelText.text = "Level 1";			buildingDetailCard.hpText.text = iconBuilding.building.hp.toString();											buildingDetailCard.setAssignments(assignments);			buildingDetailCard.setActiveContract(contract);		}				private function improvementClick(iconEntity:IconEntity) : void		{			var improvement:Improvement = Improvement(iconEntity.entity);			var assignments:Array = city.getAssignmentsByTarget(improvement.id, Entity.IMPROVEMENT);				var contract:Contract = city.getContract(improvement.id, Entity.IMPROVEMENT);						buildingDetailCard.parent.setChildIndex(buildingDetailCard, buildingDetailCard.parent.numChildren - 1);						buildingDetailCard.visible = true;			buildingDetailCard.objectNameText.text = improvement.getName();			buildingDetailCard.objectFullNameText.text = improvement.getName();			buildingDetailCard.objectNameLevelText.text = "Level 1";			buildingDetailCard.hpText.text = "0";			buildingDetailCard.setAssignments(assignments);			buildingDetailCard.setActiveContract(contract);		}								private function formClick(e:MouseEvent) : void		{			trace("formClick");			armyOverviewUI.showPanel();		}																private function trainClick(e:MouseEvent) : void		{			trace("Train Click");			trainContract.showPanel();			trainContract.init();			}						private function buildClick(e:MouseEvent) : void		{			trace("Build Click"); 			buildContract.showPanel();			buildContract.init();		}				private function craftClick(e:MouseEvent) : void		{			trace("Craft Click");			craftContract.showPanel();		}				private function craftCreateNewClick(e:CraftCreateNewEvent) : void		{			var createEvent:CraftCreateNewEvent = CraftCreateNewEvent(e);			itemBuilder.showPanel();		}				private function trainCreateNewClick(e:TrainCreateNewEvent) : void		{			var createEvent:TrainCreateNewEvent = TrainCreateNewEvent(e);			unitBuilder.showPanel();		}						private function mouseDownBuilding(e:MouseEvent) : void		{			trace("Mouse down");			e.stopPropagation();					selectedIconBuilding = IconBuilding(e.currentTarget);			startTime = getTimer();			timer.addEventListener(TimerEvent.TIMER_COMPLETE, mouseDownBuildingTimerComplete);			timer.start();		}					private function mouseDownBuildingTimerComplete(e:TimerEvent) : void		{			trace("mouseDownBuildingTimerComplete");			selectedIconBuilding.x = this.mouseX - selectedIconBuilding.width / 2;			selectedIconBuilding.y = this.mouseY - selectedIconBuilding.height / 2;						selectedIconBuilding.parent.setChildIndex(selectedIconBuilding, selectedIconBuilding.parent.numChildren - 1);				selectedIconBuilding.startDrag();			selectedIconBuilding.dragging = true;		}				private function mouseUpBuilding(e:MouseEvent): void		{			trace("Mouse Up");			var iconBuilding:IconBuilding = IconBuilding(e.currentTarget);			var endTime:int = getTimer();						timer.stop();						if((endTime - startTime) < 250)			{				buildingClick(iconBuilding);			}			else			{				e.stopPropagation();				var building:Building = Building(iconBuilding.building);								iconBuilding.stopDrag();				iconBuilding.dragging = false;				iconBuilding.x = iconBuilding.anchorX;				iconBuilding.y = iconBuilding.anchorY;								if(craftContract.selectSource.contains(iconBuilding.dropTarget))				{					craftContract.setBuilding(building);				}				else if(trainContract.selectSource.contains(iconBuilding.dropTarget))				{					trainContract.setBuilding(building);				}			}		}		private function mouseDownImprovement(e:MouseEvent) : void		{			trace("Mouse down");			e.stopPropagation();			selectedIconImprovement = IconEntity(e.currentTarget);			startTime = getTimer();			timer.addEventListener(TimerEvent.TIMER_COMPLETE, mouseDownImprovementTimerComplete);			timer.start();				}						private function mouseDownImprovementTimerComplete(e:TimerEvent) : void		{			selectedIconImprovement.x = this.mouseX - selectedIconImprovement.width / 2;			selectedIconImprovement.y = this.mouseY - selectedIconImprovement.height / 2;						selectedIconImprovement.parent.setChildIndex(selectedIconImprovement, selectedIconImprovement.parent.numChildren - 1);			selectedIconImprovement.startDrag();					}				private function mouseUpImprovement(e:MouseEvent) : void		{			trace("Mouse up");				var iconEntity:IconEntity = IconEntity(e.currentTarget);			var endTime:int = getTimer();						timer.stop();						if((endTime - startTime) < 250)			{				improvementClick(iconEntity);			}						else 			{				e.stopPropagation();													var improvement:Improvement = Improvement(iconEntity.entity);								iconEntity.stopDrag();				iconEntity.x = iconEntity.anchorX;				iconEntity.y = iconEntity.anchorY;								if(craftContract.selectSource.contains(iconEntity.dropTarget))				{					craftContract.setImprovement(improvement);				}			}		}								private function removeImprovementIcons():void		{			if(improvementIcons != null)			{				for (var i:int = 0; i < improvementIcons.length; i++)				{										if(this.contains(improvementIcons[i]))						this.removeChild(improvementIcons[i]);				}					improvementIcons.length = 0;			}		}							private function removeBuildingIcons() : void		{			if(buildingsIcons != null)			{				for (var i:int = 0; i < buildingsIcons.length; i++)				{										if(this.contains(buildingsIcons[i]))						this.removeChild(buildingsIcons[i]);				}					buildingsIcons.length = 0;			}		}								private function clearInfoColumn() : void		{			removeImprovementIcons();			removeBuildingIcons();		}				private function topImprovementsInfo() : void		{			improvementsInfo.y = IMPROVEMENTS_INFO_Y_TOP;		}				private function bottomImprovementsInfo() : void		{			improvementsInfo.y = IMPROVEMENTS_INFO_Y_BOTTOM;		}						private function showActivatedInfoPanel() : void		{			switch(activatedInfoColumn)			{				case BUILDINGS_INFO:					clearInfoColumn();					bottomImprovementsInfo();										//Setup building icons					setBuildingIcons();					activatedInfoColumn = BUILDINGS_INFO;					break;			}		}				private function showCityUI(e:ShowCityUIEvent) : void		{			var showCityUI:ShowCityUIEvent = ShowCityUIEvent(e);						setCity(showCityUI.city);			showPanel();		}				private function itemTransfered(e:ParamEvent) : void		{			trace("CityUI itemTransfered");			if(inventoryUI == Game.INSTANCE.lastTransferItem.sourceUI ||			   this.contains(Game.INSTANCE.lastTransferItem.targetUI))			{				trace("Refresh City UI");				Game.INSTANCE.requestInfo(Entity.CITY, city.id);			}					}				private function unitTransfered(e:ParamEvent) : void		{			trace("CityUI unitTransfered");			if(unitsUI == Game.INSTANCE.lastTransferUnit.sourceUI ||			   this.contains(Game.INSTANCE.lastTransferUnit.targetUI))			{				trace("Refresh City UI");				Game.INSTANCE.requestInfo(Entity.CITY, city.id);			}					}				private function perceptionUpdate(e:ParamEvent) : void		{			if(armyOverviewUI.visible)							armyOverviewUI.updatePanel();		}						private function closeButtonClick(e:MouseEvent) : void		{			this.visible = false;		}				private function buildingDetailCloseClick(e:MouseEvent) : void		{			buildingDetailCard.visible = false;		}				private function showAssignPopUp(taskType:int, taskId:int, objectName:String, 										 caste:int, race:int, amount:int) : void		{			this.setChildIndex(disableBackground, this.numChildren - 1);			disableBackground.visible = true;									this.setChildIndex(assignPopUI, this.numChildren - 1);				assignPopUI.visible = true;						assignPopUI.taskType = taskType;			assignPopUI.taskId = taskId;			assignPopUI.caste = caste;			assignPopUI.race = race;			assignPopUI.amount = amount;						assignPopUI.objectFullNameText.text = objectName;			assignPopUI.objectNameLevelText.text = "";			assignPopUI.casteNameText.text = Population.getCasteName(caste) + " " + Population.getRaceName(race);			assignPopUI.popInputText.stage.focus = assignPopUI.popInputText;			assignPopUI.popInputText.text = amount.toString();		}				private function hidePopUps() : void		{			disableBackground.visible = false;			assignPopUI.visible = false;			buildingDetailCard.visible = false;			trainContract.visible = false;			buildContract.visible = false;			craftContract.visible = false;			itemBuilder.visible = false;			unitBuilder.visible = false;			armyOverviewUI.visible = false;		}				private function setPopUpsDisplayIndex() : void		{			this.setChildIndex(buildingDetailCard, this.numChildren - 1);			this.setChildIndex(trainContract, this.numChildren - 1);			this.setChildIndex(buildContract, this.numChildren - 1);			this.setChildIndex(craftContract, this.numChildren - 1);			this.setChildIndex(itemBuilder, this.numChildren - 1);			this.setChildIndex(unitBuilder, this.numChildren - 1);			this.setChildIndex(armyOverviewUI, this.numChildren - 1);			}				private function hidePanels() : void		{			inventoryUI.hidePanel();			financesUI.hidePanel();			populationUI.hidePanel();			throneUI.hidePanel();			unitsUI.hidePanel();		}				private function assignPopInputTextMouseOut(e:MouseEvent) : void		{			trace("assignPopInputTextMouseOut");			//Mouse.cursor = "arrow";		}				private function mouseClick(e:MouseEvent) : void		{			this.parent.setChildIndex(this, this.parent.numChildren - 1);				e.stopImmediatePropagation();		}				private function mouseDown(e:MouseEvent) : void		{				this.parent.setChildIndex(this, this.parent.numChildren - 1);				startDrag();						e.stopImmediatePropagation();		}						private function mouseUp(e:MouseEvent) : void		{			trace("MouseUp: " + parent);						stopDrag();			e.stopImmediatePropagation();		}	}	}