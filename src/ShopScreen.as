package
{
	import com.adobe.serialization.json.JSON;
	import com.bit101.components.ComboBox;
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.ListItem;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.screens.BaseScreen;
	import com.pblabs.screens.ScreenManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.profiler.showRedrawRegions;
	
	import com.forgestory.model.Item;
	import com.forgestory.model.Player;
	
	import com.forgestory.networking.GameNetworkConnection;
	
	import com.forgestory.rpg.BuySuccessWindow;
	import com.forgestory.rpg.BuyWindow;
	import com.forgestory.rpg.FacebookShower;
	import com.forgestory.rpg.ItemDataObject;
	import com.forgestory.rpg.ItemViewer;
	import com.forgestory.rpg.PlayerData;
	import com.forgestory.rpg.PlayerDataObject;
	
	public class ShopScreen extends BaseScreen{
		private var backButton:PushButton;
		private var buyButton:PushButton;
		
		private var itemList:List;
		
		private var shopListComboBox:ComboBox;
		
		private var itemImage:ItemViewer;
		
		private var nameLabel:Label;
		private var descriptionLabel:Label;
		
		private var vBoxRight:VBox;
		private var vBoxLeft:VBox;
		
		private var hBox:HBox;
		
		private var isOnFriendsShop:Boolean = false;
		
		private var itemListArray:Array;
		private var itemArray:Array;
		
		private var buyWindow:BuyWindow;
		private var buySuccessWindow:BuySuccessWindow;
		
		public function ShopScreen(){
			super();
			
			vBoxRight = new VBox(this, 400, 100);
			vBoxLeft = new VBox(this, 100, 300);
			hBox = new HBox(this, 400, 400);
			
			shopListComboBox = new ComboBox(vBoxRight, 0, 0, "My Shop", ["My Shop", "Friend 1", "Friend 2"]);
			shopListComboBox.addEventListener(Event.SELECT, onComboBoxSelected);
			shopListComboBox.width = 250;
			
			itemList = new List(vBoxRight, 0, 0);
			itemList.addEventListener(Event.SELECT, onItemSelected);
			itemList.width = 250;
			
			itemImage = new ItemViewer();
			itemImage.y = 100;
			itemImage.x = 100;
			itemImage.scaleX = 3;
			itemImage.scaleY = 3;
			addChild(itemImage);
			
			nameLabel = new Label(vBoxLeft, 0, 0, "None ");
			descriptionLabel = new Label(vBoxLeft, 0, 0, "If you can't see an item here, it's probably because you haven't made one. Or your internet is slow.");
				
			buyButton = new PushButton(hBox, 0, 0, "Share", onBuyButton);
			backButton = new PushButton(hBox, 0, 0, "Home", onBackButton);
			
			buyWindow = new BuyWindow(this, 320, 100, "Please confirm buy?");
			buyWindow.addEventListener(Event.CLOSE, onWindowCancel);
			buyWindow.setBuyAndCancelCallBacks(onBuyConfirm, onWindowCancel);
			buyWindow.visible = false;
			
			buySuccessWindow = new BuySuccessWindow(this, 320, 100, "Success!");
			buySuccessWindow.visible = false;
			buySuccessWindow.addEventListener(Event.CLOSE, onBuySuccessClosed);
			buySuccessWindow.addEventListener(MouseEvent.CLICK, onBuySuccessClosed);
			
		}
		
		private function onComboBoxSelected(evt:Event):void{
			Logger.print(this, "ComboBox selected!");
			if(shopListComboBox.selectedIndex == 0){
				buyButton.label = "Share";
				isOnFriendsShop = false;
				loadShopData(PlayerData.instance.player.uid);
			}else{
				buyButton.label = "Buy";
				isOnFriendsShop = true;
				loadShopData((shopListComboBox.selectedItem as Player).uid);
			}
		}
		
		public function enable(val:Boolean):void{
			buyButton.enabled = val;
			backButton.enabled = val;
			shopListComboBox.enabled = val;
			itemList.enabled = val;
		}
		
		private function onBuySuccessClosed(evt:Event):void{
			enable(true);
		}
		
		private function onBuyConfirm(evt:Event):void{
			buyWindow.enable(false);
			buyItem();
		}
		
		private function onWindowCancel(evt:Event):void{
			enable(true);
			buyWindow.enable(false);
		}
		
		private function onItemSelected(evt:Event):void{
			var currItem:Item = itemList.selectedItem as Item;
			setDisplayedItem(currItem);
			if(currItem.type == Item.MONSTER){
				buyButton.enabled = false;
			}else{
				if(PlayerData.instance.player.coins - currItem.price <= 0){
					buyButton.enabled = false;
				}else{
					buyButton.enabled = true;
				}
			}
		}
		
		private function onBackButton(evt:Event):void{
			ScreenManager.instance.goto(DangerItems.WELCOME);
		}
		
		private function onBuyButton(evt:Event):void{
			if(isOnFriendsShop){
				if((itemList.selectedItem as Item).type == Item.MONSTER){
					//DangerItems.monster = itemList.selectedItem as ItemDataObject;
					//ScreenManager.instance.goto(DangerItems.ADVENTURE);
				}else{
					buyWindow.enable(true);
					buyWindow.setItem(itemList.selectedItem as Item);
					enable(false);
				}
			}else{
				FacebookShower.instance.showUI(itemList.selectedItem as Item);
			}
		}
		
		override public function onShow():void{
			loadBuddiesData();
			//loadShopData(PlayerData.instance.player.uid);
		}
		
		override public function onHide():void{
			
		}
		
		private function setDisplayedItem(itemDisplayed:Item):void{
			descriptionLabel.text = itemDisplayed.description;
			nameLabel.text = itemDisplayed.name;
			itemImage.setURL(itemDisplayed.id+".png");
		}
		
		private function buyItem():void{
			GameNetworkConnection.instance.buyItem(onBuyItem, itemList.selectedItem as Item, PlayerData.instance.player, false);
		}
		
		private function onBuyItem(result:Object):void{
			if(result == "Success"){
				buySuccessWindow.visible = true;
			}else{
				Logger.print(this, "Error! " + result);
			}
		}
		
		private function loadBuddiesData():void{
			GameNetworkConnection.instance.getPlayerBuddies(onBuddiesLoaded, PlayerData.instance.player);
		}
		
		private function onBuddiesLoaded(result:Object):void{
			//var obj:Array = JSON.decode(evt.target.data);
			Logger.print(this, "Buddies Loaded (length): " + result.length);
			shopListComboBox.removeAll();
			shopListComboBox.addItem("My Shop");
			for(var i:int = 0; i < result.length; i++){
				shopListComboBox.addItem(result[i]);
			}
			shopListComboBox.selectedIndex = 0;
			//loadShopData(PlayerData.instance.player.uid);
		}
		
		private function loadShopData(uid:String):void{
			itemList.enabled = false;
			GameNetworkConnection.instance.getInventory(onShopDataLoaded, uid, new Item());
		}
		
		private function onShopDataLoaded(result:Object):void{
			Logger.print(this, "Loaded Inventory (size): " + result.length);
			itemList.removeAll();
			if(result.length == 0){
				return;
			}else{
				for(var i:int = 0; i < result.length; i++){
					itemList.addItem(result[i]);
				}
				itemList.selectedIndex = 0;
				setDisplayedItem(itemList.selectedItem as Item);
			}
			itemList.enabled = true;
		}
	}
}