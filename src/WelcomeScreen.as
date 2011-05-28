package
{
	import com.adobe.serialization.json.JSON;
	import com.bit101.components.HBox;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.screens.BaseScreen;
	import com.pblabs.screens.ScreenManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import model.Item;
	import model.Player;
	
	import networking.GameNetworkConnection;
	
	import rpg.Avatar;
	import rpg.BuySuccessWindow;
	import rpg.BuyWindow;
	import rpg.ItemDataObject;
	import rpg.PlayerData;
	import rpg.UserDataPanel;
	import rpg.WelcomePanel;
	
	public class WelcomeScreen extends BaseScreen
	{
		private var welcomeWindow:Window;
		private var welcomePanel:WelcomePanel;
		
		private var userDataPanel:UserDataPanel;
		
		private var _shopButton:PushButton;
		private var _forgeButton:PushButton;
		private var _goAloningButton:PushButton;
		private var _editAvatarButton:PushButton;
		
		private var _buttonBox:HBox;
		
		private var _avatar:Avatar;
		
		private var buyWindow:BuyWindow;
		private var buySuccessWindow:BuySuccessWindow;
		
		//private var loadedItem:ItemDataObject;
		
		private var loadedItem:Item;
		
		public function WelcomeScreen()
		{
			super();
			
			_avatar = PlayerData.instance.avatar;
			_avatar.setBody(PlayerData.instance.player.body+".png");
			_avatar.setHead(PlayerData.instance.player.head+".png");
			
			_buttonBox = new HBox(this, 400, 400);
			
			_shopButton = new PushButton(_buttonBox, 0, 0, "Shop", onShopButton);
			_forgeButton = new PushButton(_buttonBox, 100, 0, "Forge", onForgeButton);
			_goAloningButton = new PushButton(_buttonBox, 0, 0, "Go Aloning!!", onGoAloningButton);
			_goAloningButton.enabled = false;
			
			_editAvatarButton = new PushButton(this, 150, 450, "Customize", onCustomize);
			
			userDataPanel = new UserDataPanel(this, 400, 100);
			
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
			addChild(_avatar);
			_avatar.x = 100;
			_avatar.y = 100;
			
			_avatar.scaleX = 3;
			_avatar.scaleY = 3;
			
			_avatar.setBody(PlayerData.instance.player.body+".png");
			_avatar.setHead(PlayerData.instance.player.head+".png");
			
			userDataPanel.updateArmorImage(PlayerData.instance.player.armor);
			userDataPanel.updateWeaponImage(PlayerData.instance.player.weapon);
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