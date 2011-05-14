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
	
	import rpg.BuySuccessWindow;
	import rpg.BuyWindow;
	import rpg.FacebookShower;
	import rpg.ItemDataObject;
	import rpg.ItemViewer;
	import rpg.PlayerData;
	import rpg.PlayerDataObject;
	
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
			if(shopListComboBox.selectedIndex == 0){
				buyButton.label = "Share";
				isOnFriendsShop = false;
				loadShopData(PlayerData.instance.uid);
			}else{
				buyButton.label = "Buy";
				isOnFriendsShop = true;
				loadShopData((shopListComboBox.selectedItem as PlayerDataObject).uid);
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
			var currItem:ItemDataObject = itemList.selectedItem as ItemDataObject;
			setDisplayedItem(currItem);
			if(currItem.type == ItemDataObject.MONSTER){
				buyButton.enabled = false;
			}else{
				if(PlayerData.instance.coins - currItem.price <= 0){
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
				if((itemList.selectedItem as ItemDataObject).type == ItemDataObject.MONSTER){
					//DangerItems.monster = itemList.selectedItem as ItemDataObject;
					//ScreenManager.instance.goto(DangerItems.ADVENTURE);
				}else{
					buyWindow.enable(true);
					buyWindow.setItem(itemList.selectedItem as ItemDataObject);
					enable(false);
				}
			}else{
				FacebookShower.instance.showUI(itemList.selectedItem as ItemDataObject);
			}
		}
		
		override public function onShow():void{
			loadBuddiesData();
			loadShopData(PlayerData.instance.uid);
		}
		
		override public function onHide():void{
			
		}
		
		private function setDisplayedItem(itemDisplayed:ItemDataObject):void{
			descriptionLabel.text = itemDisplayed.description;
			nameLabel.text = itemDisplayed.name;
			itemImage.setURL(itemDisplayed.id+".png");
		}
		
		private function buyItem():void{
			var selectedItem:ItemDataObject = (itemList.selectedItem as ItemDataObject);
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.uid = PlayerData.instance.uid;
			urlVariables.forger_id = selectedItem.forger_id;
			urlVariables.item_id = selectedItem.id;
			urlVariables.item_sell_price = selectedItem.price;
			urlVariables.item_buy_price = selectedItem.price;
			
			var urlRequest:URLRequest = new URLRequest("buyItem.php");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVariables;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onBuyItem);
			urlLoader.load(urlRequest);
		}
		
		private function onBuyItem(evt:Event):void{
			if(evt.target.data == "Success"){
				buySuccessWindow.visible = true;
			}else{
				Logger.print(this, "Error: " + evt.target.data);
			}
		}
		
		private function loadBuddiesData():void{
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.uid = PlayerData.instance.uid;
			
			var urlRequest:URLRequest = new URLRequest("getPlayerBuddies.php");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVariables;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onBuddiesLoaded);
			urlLoader.load(urlRequest);
		}
		
		private function onBuddiesLoaded(evt:Event):void{
			var obj:Array = JSON.decode(evt.target.data);
			Logger.print(this, "Buddies: " + obj.length);
			shopListComboBox.removeAll();
			shopListComboBox.addItem("My Shop");
			for(var i:int = 0; i < obj.length; i++){
				var playerData:PlayerDataObject = new PlayerDataObject();
				playerData.uid = obj[i][0];
				playerData.username = obj[i][1];
				playerData.head = obj[i][2];
				playerData.body = obj[i][3];
				shopListComboBox.addItem(playerData);
			}
			shopListComboBox.selectedIndex = 0;
		}
		
		private function loadShopData(uid:String):void{
			itemList.enabled = false;
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.uid = uid;
			
			var urlRequest:URLRequest = new URLRequest("getPlayerItems.php");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVariables;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onShopDataLoaded);
			urlLoader.load(urlRequest);
		}
		
		private function onShopDataLoaded(evt:Event):void{
			var obj:Array = JSON.decode(evt.target.data);
			Logger.print(this, "Size: " + obj.length);
			itemList.removeAll();
			if(obj.length == 0){
				return;
			}else{
				for(var i:int = 0; i < obj.length; i++){
					var itemData:ItemDataObject = new ItemDataObject();
					itemData.id = obj[i][0];
					itemData.name = obj[i][1];
					itemData.forger_id = obj[i][2];
					itemData.price = obj[i][3];
					itemData.type = obj[i][4];
					itemData.taken = obj[i][5];
					itemData.description = obj[i][6];
					itemList.addItem(itemData);
				}
				itemList.selectedIndex = 0;
				setDisplayedItem(itemList.selectedItem as ItemDataObject);
			}
			itemList.enabled = true;
		}
	}
}