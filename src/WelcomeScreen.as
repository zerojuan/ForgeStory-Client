package
{
	import com.forgestory.model.Item;
	import com.forgestory.model.Player;
	import com.forgestory.networking.GameNetworkConnection;
	import com.forgestory.rpg.Avatar;
	import com.forgestory.rpg.BuySuccessWindow;
	import com.forgestory.rpg.BuyWindow;
	import com.forgestory.rpg.PlayerData;
	import com.forgestory.rpg.UserDataPanel;
	import com.forgestory.rpg.WelcomePanel;
	import com.forgestory.ui.AvatarPanel;
	import com.forgestory.ui.GameUIStyle;
	import com.forgestory.ui.ItemPanel;
	import com.forgestory.ui.MenuButton;
	import com.greensock.TweenLite;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.screens.BaseScreen;
	import com.pblabs.screens.ScreenManager;
	import com.zerojuan.ui.HBox;
	import com.zerojuan.ui.Label;
	import com.zerojuan.ui.PushButton;
	import com.zerojuan.ui.TextArea;
	import com.zerojuan.ui.Window;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class WelcomeScreen extends BaseScreen
	{
		private var welcomeWindow:Window;
		private var welcomePanel:WelcomePanel;
		
		private var _shopButton:MenuButton;
		private var _forgeButton:MenuButton;
		private var _goAloningButton:MenuButton;
		private var _editAvatarButton:PushButton;
				
		private var _avatarPanel:AvatarPanel;
		private var _weaponPanel:ItemPanel;
		private var _armorPanel:ItemPanel;
		
		private var _awardLabel:Label;
		private var _nameLabel:Label;
		private var _levelLabel:Label;
		private var _statsLabel:Label;
		
		private var _userDescription:TextArea;
		
		private var _buttonBox:HBox;
		
		private var _avatar:Avatar;
		
		private var buyWindow:BuyWindow;
		private var buySuccessWindow:BuySuccessWindow;
		
		private var loadedItem:Item;
		
		private var _namePos:Point;
		private var _levelPos:Point;
		private var _statsPos:Point;
		private var _userDescPos:Point;
		private var _avatarPos:Point;
		private var _weaponPos:Point;
		private var _armorPos:Point;
		private var _awardPos:Point;
		private var _buttonPos:Point;
		
		public function WelcomeScreen()
		{
			super();
			
			//setup layout positions
			_avatarPos = new Point(45, 100);
			_weaponPos = new Point(25, 290);
			_armorPos = new Point(25, 400);
			_buttonPos = new Point(500, 450);
			_userDescPos = new Point(360, 100);
			_namePos = new Point(10, 15);
			_levelPos = new Point(410, 20);
			_statsPos = new Point(410, 50);
			_awardPos = new Point(360, 240);
			
			//add background image
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xa3d3f9);
			bg.graphics.drawRect(0, 0, 760, 520);
			bg.graphics.endFill();
			addChild(bg);
			
			_avatar = PlayerData.instance.avatar;
			_avatar.setBody(PlayerData.instance.player.body+".png");
			_avatar.setHead(PlayerData.instance.player.head+".png");
			
			_avatarPanel = new AvatarPanel(this, _avatarPos.x, _avatarPos.y, _avatar);
			
			_weaponPanel = new ItemPanel(this, _weaponPos.x, _weaponPos.y);
			_armorPanel = new ItemPanel(this, _armorPos.x, _armorPos.y);
			
			_buttonBox = new HBox(this, _buttonPos.x, _buttonPos.y);
			_buttonBox.spacing = 10;
			
			_shopButton = new MenuButton(_buttonBox, 0, 0, MenuButton.SHOP, onShopButton);
			_forgeButton = new MenuButton(_buttonBox, 100, 0, MenuButton.FORGE, onForgeButton);
			_goAloningButton = new MenuButton(_buttonBox, 0, 0, MenuButton.ADVENTURE, onGoAloningButton);
			_goAloningButton.enabled = false;
			
			_editAvatarButton = new PushButton(this, 150, 450, "Customize", onCustomize);
			
			_userDescription = new TextArea(this, _userDescPos.x, _userDescPos.y, "Isn't the hero you need but the hero you deserve");
			_userDescription.setSize(360, 150);		
			_userDescription.editable = false;
			_userDescription.autoHideScrollBar = true;
			_userDescription.setStyle("Bellerose", 30, GameUIStyle.RED_HIGHLIGHT);
			
			
			welcomeWindow = new Window(this, 320, 100, "Welcome, Person from Facebook");
			welcomeWindow.hasCloseButton = true;
			welcomeWindow.width = 250;
			welcomeWindow.height = 120;
			welcomeWindow.addEventListener(Event.CLOSE, onCloseWelcomeWindow);
			welcomeWindow.visible = PlayerData.instance.player.isNew;
			
			welcomePanel = new WelcomePanel(welcomeWindow, 0, 0);
			welcomePanel.cancelCallback = onCloseWelcomeWindow;
			
			buyWindow = new BuyWindow(this, 320, 100, "Please confirm buy?");
			buyWindow.addEventListener(Event.CLOSE, onWindowCancel);
			buyWindow.setBuyAndCancelCallBacks(onBuyConfirm, onWindowCancel);
			buyWindow.visible = false;
			
			buySuccessWindow = new BuySuccessWindow(this, 320, 100, "Success!");
			buySuccessWindow.visible = false;
			buySuccessWindow.addEventListener(Event.CLOSE, onBuySuccessClosed);
			buySuccessWindow.addEventListener(MouseEvent.CLICK, onBuySuccessClosed);
			
			_nameLabel = new Label(this, _namePos.x, _namePos.y, "JULIUS THE HEROES");
			_nameLabel.name = "LabelExists";
			
			_levelLabel = new Label(this, _levelPos.x, _levelPos.y, "Master of the Universe");
			_levelLabel.setStyle("Redhead", 24, GameUIStyle.MAIN_HIGHLIGHT);
			
			_statsLabel = new Label(this, _statsPos.x, _statsPos.y, "W 1 D 0 L 4 -- $ 10,000.00");
			_statsLabel.setStyle("Redhead", 24, GameUIStyle.MAIN_HIGHLIGHT);
			
			_awardLabel = new Label(this, _awardPos.x, _awardPos.y, "AWARDS")
			_awardLabel.setStyle("Bellerose", 24, GameUIStyle.MAIN_HIGHLIGHT);
			
		}
		
		private function onForgeClicked(evt:MouseEvent):void{
			Logger.print(this, "ForgeClicked");
		}
		
		private function onBuySuccessClosed(evt:Event):void{
			buySuccessWindow.visible = false;
			PlayerData.instance.linkedUID = "NONE";
		}
		
		private function onWindowCancel(evt:Event):void{
			PlayerData.instance.linkedUID = "NONE";
		}
		
		private function onBuyConfirm(evt:Event):void{
			buyWindow.enable(false);
			buyItem();
		}
		
		private function buyItem():void{
			GameNetworkConnection.instance.buyItem(onBuyItem, loadedItem, PlayerData.instance.player, true);
		}
		
		private function onBuyItem(result:Object):void{
			if(result == "Success"){
				buySuccessWindow.visible = true;
			}else{
				Logger.print(this, "Error!");
			}
		}
		
		override public function onShow():void{
			if(PlayerData.instance.linkedUID != "NONE"){
				welcomeWindow.visible = true;
				if(PlayerData.instance.linkedUID == "INVALID"){
					welcomePanel.setMessage("The item your friend gave you was invalid. Sorry try again next time");
				}else if(PlayerData.instance.linkedUID == "OWNED"){
					welcomePanel.setMessage("But. But.. You already owned that item. Don't be so greedy.");
				}else{
					loadItem();
				}
			}
			
			loadPlayerData();
			
			show();
		}
		
		override public function onHide():void{
			
		}
		
		private function loadItem():void{
			var item:Item = new Item();
			item.id = PlayerData.instance.linkedUID;
			
			GameNetworkConnection.instance.getItem(onItemLoaded, item);
		}
		
		private function onItemLoaded(result:Object):void{
			if(result is Item){
				loadedItem = result as Item;
			}else{
				Logger.print(this, "Error loading free item");
			}
			
			buyWindow.visible = true;
			buyWindow.isSpecial(loadedItem);
		}
		
		private function onCloseWelcomeWindow(evt:Event):void{
			welcomeWindow.visible = false;
		}
		
		private function onShopButton(evt:Event):void{
			hideThenGoTo(DangerItems.SHOP);
		}
		
		private function onForgeButton(evt:Event):void{
			hideThenGoTo(DangerItems.FORGE);
		}
		
		private function onGoAloningButton(evt:Event):void{
			hideThenGoTo(DangerItems.ADVENTURE);
		}
		
		private function onCustomize(evt:Event):void{
			hideThenGoTo(DangerItems.EDIT_AVATAR);
		}
		
		private function show():void{
			_nameLabel.x = -300;
			_statsLabel.x = 900;
			_levelLabel.x = 900;
			_avatarPanel.x = -400;
			_armorPanel.alpha = 0;
			_armorPanel.x = -400;
			_weaponPanel.x = -400;
			_weaponPanel.alpha = 0;
			_userDescription.x = 900;
			_awardLabel.alpha = 0;
			_awardLabel.y = _awardPos.y - 20;
			
			_forgeButton.y = 500;
			_shopButton.y = 500;
			_goAloningButton.y = 500;
			
			TweenLite.to(_nameLabel, .4, {x: _namePos.x});
			TweenLite.to(_statsLabel, .43, {x: _statsPos.x});
			TweenLite.to(_levelLabel, .47, {x: _levelPos.x});
			
			TweenLite.to(_avatarPanel, .5, {x: _avatarPos.x, onComplete: function():void{
				TweenLite.to(_armorPanel, .2, {alpha: 1, x: _armorPos.x});
				TweenLite.to(_weaponPanel, .2, {alpha: 1, x: _weaponPos.x});
			}});
			
			TweenLite.to(_userDescription, .52, {x: _userDescPos.x, onComplete: function():void{
				TweenLite.to(_awardLabel, .1, {alpha: 1, y: _awardPos.y});
			}});
			
			TweenLite.to(_shopButton, .3, {y: 0});
			TweenLite.to(_forgeButton, .32, {y: 0});
			TweenLite.to(_goAloningButton, .33, {y: 0});
			
			_shopButton.enabled = true;
			_forgeButton.enabled = true;
			//_goAloningButton.enabled = true;
		}
		
		private function hideThenGoTo(screen:String):void{
			Logger.print(this, "Hiding");
			_shopButton.enabled = false;
			_forgeButton.enabled = false;
			_goAloningButton.enabled = false;
			
			TweenLite.to(_weaponPanel, .2, {alpha: 0, x: -400});
			TweenLite.to(_armorPanel, .2, {alpha: 0, x: -400, onComplete: function():void{
				TweenLite.to(_avatarPanel, .3, {x: -400});
				
			}});
			
			TweenLite.to(_shopButton, .5, {y: 500});
			TweenLite.to(_forgeButton, .47, {y: 500});
			TweenLite.to(_goAloningButton, .43, {y: 500});
			
			TweenLite.to(_awardLabel, .20, {y: _awardPos.y - 20, alpha: 0, onComplete: function():void{
				TweenLite.to(_userDescription, .3, {x: 900});
			}});
			
			TweenLite.to(_nameLabel, .8, {x: -500, onComplete:function():void{
				TweenLite.to(this, .2, {onComplete:function():void{
					ScreenManager.instance.goto(screen);
				}});
			}});
			TweenLite.to(_statsLabel, .65, {x: 900});
			TweenLite.to(_levelLabel, .6, {x: 900});
			
		}
		
		private function showAvatar():void{
			_avatar.x = 25;
			_avatar.y = 25;
			
			_avatar.scaleX = 3;
			_avatar.scaleY = 3;
			
			_avatar.setBody(PlayerData.instance.player.body+".png");
			_avatar.setHead(PlayerData.instance.player.head+".png");
			
			_weaponPanel.item.setURL(PlayerData.instance.player.weapon+".png");
			_armorPanel.item.setURL(PlayerData.instance.player.armor+".png");
			//userDataPanel.updateWeaponImage(PlayerData.instance.player.weapon);
		}
		
		private function loadPlayerData():void{
			GameNetworkConnection.instance.getPlayer(onPlayerDataLoaded, PlayerData.instance.player);
		}
		
		private function onPlayerDataLoaded(result:Object):void{
			if(result is Player){
				PlayerData.instance.player = result as Player;
			}
			
			showAvatar();
		}
	}
}