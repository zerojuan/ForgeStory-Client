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
	
	public class WelcomeScreen extends BaseScreen
	{
		private var welcomeWindow:Window;
		private var welcomePanel:WelcomePanel;
		
		private var userDataPanel:UserDataPanel;
		
		private var _shopButton:PushButton;
		private var _forgeButton:PushButton;
		private var _goAloningButton:PushButton;
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
		
		//private var loadedItem:ItemDataObject;
		
		private var loadedItem:Item;
		
		public function WelcomeScreen()
		{
			super();
			
			//add background image
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xa3d3f9);
			bg.graphics.drawRect(0, 0, 760, 520);
			bg.graphics.endFill();
			addChild(bg);
			
			_avatar = PlayerData.instance.avatar;
			_avatar.setBody(PlayerData.instance.player.body+".png");
			_avatar.setHead(PlayerData.instance.player.head+".png");
			
			_avatarPanel = new AvatarPanel(this, 45, 100, _avatar);
			
			_weaponPanel = new ItemPanel(this, 25, 290);
			_armorPanel = new ItemPanel(this, 25, 400);
			
			_buttonBox = new HBox(this, 400, 400);
			
			_shopButton = new PushButton(_buttonBox, 0, 0, "Shop", onShopButton);
			_forgeButton = new PushButton(_buttonBox, 100, 0, "Forge", onForgeButton);
			_goAloningButton = new PushButton(_buttonBox, 0, 0, "Go Aloning!!", onGoAloningButton);
			_goAloningButton.enabled = false;
			
			_editAvatarButton = new PushButton(this, 150, 450, "Customize", onCustomize);
			
			_userDescription = new TextArea(this, 360, 100, "Isn't the hero you need but the hero you deserve");
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
			
			_nameLabel = new Label(this, 10, 15, "JULIUS THE HEROES");
			_nameLabel.name = "LabelExists";
			
			_levelLabel = new Label(this, 410, 20, "Master of the Universe");
			_levelLabel.setStyle("Redhead", 24, GameUIStyle.MAIN_HIGHLIGHT);
			
			_statsLabel = new Label(this, 410, 50, "W 1 D 0 L 4 -- $ 10,000.00");
			_statsLabel.setStyle("Bellerose", 24, GameUIStyle.MAIN_HIGHLIGHT);
			
			_awardLabel = new Label(this, 360, 240, "AWARDS")
			_awardLabel.setStyle("Bellerose", 24, GameUIStyle.MAIN_HIGHLIGHT);
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
			ScreenManager.instance.goto(DangerItems.SHOP);
		}
		
		private function onForgeButton(evt:Event):void{
			ScreenManager.instance.goto(DangerItems.FORGE);
		}
		
		private function onGoAloningButton(evt:Event):void{
			ScreenManager.instance.goto(DangerItems.ADVENTURE);
		}
		
		private function onCustomize(evt:Event):void{
			ScreenManager.instance.goto(DangerItems.EDIT_AVATAR);
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