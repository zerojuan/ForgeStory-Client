package
{
	import com.adobe.serialization.json.JSON;
	import com.bit101.components.ComboBox;
	import com.bit101.components.HBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.screens.BaseScreen;
	import com.pblabs.screens.ScreenManager;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import rpg.Avatar;
	import rpg.ItemDataObject;
	import rpg.ItemViewer;
	import rpg.PlayerData;
	
	public class EditAvatarScreen extends BaseScreen{
		private var editNameText:InputText;
		private var headComboBox:ComboBox;
		private var bodyComboBox:ComboBox;
		private var armorComboBox:ComboBox;
		private var weaponComboBox:ComboBox;
		
		private var headNameLabel:Label;
		private var bodyNameLabel:Label;
		private var armorNameLabel:Label;
		private var weaponNameLabel:Label;
		
		private var headDescLabel:Label;
		private var bodyDescLabel:Label;
		private var armorDescLabel:Label;
		private var weaponDescLabel:Label;
		
		private var avatar:Avatar;
		private var weaponHolder:ItemViewer;
		private var armorHolder:ItemViewer;
		
		private var vBoxLeft:VBox;
		private var vBoxRight:VBox;
		private var hBox:HBox;
		
		private var backButton:PushButton;
		private var saveButton:PushButton;
		
		private var headValue:String;
		private var bodyValue:String;
		private var armorValue:String;
		private var weaponValue:String;
		
		public function EditAvatarScreen(){
			vBoxRight = new VBox(this, 400, 100);
			vBoxRight.spacing = 2;
			vBoxLeft = new VBox(this, 100, 300);
			hBox = new HBox(this, 400, 400);
			
			editNameText = new InputText(vBoxRight, 0, 0, PlayerData.instance.username);
			editNameText.width = 200;
			headComboBox = new ComboBox(vBoxRight, 0, 0);
			headComboBox.width = 200;
			headNameLabel = new Label(vBoxRight, 0, 0, "Head Item Name");
			headNameLabel.width = 200;
			headDescLabel = new Label(vBoxRight, 0, 0, "Head Desc Label");
			headDescLabel.autoSize = true;
			headDescLabel.textField.width = 250;
			headDescLabel.textField.wordWrap = true;
			bodyComboBox = new ComboBox(vBoxRight, 0, 0);
			bodyComboBox.width = 200;
			bodyNameLabel = new Label(vBoxRight, 0, 0, "Head Item Name");
			bodyNameLabel.width = 200;
			bodyDescLabel = new Label(vBoxRight, 0, 0, "Head Desc Label");
			bodyDescLabel.autoSize = true;
			bodyDescLabel.textField.width = 250;
			bodyDescLabel.textField.wordWrap = true;
			armorComboBox = new ComboBox(vBoxRight, 0, 0);
			armorComboBox.width = 200;
			armorNameLabel = new Label(vBoxRight, 0, 0, "Head Item Name");
			armorNameLabel.width = 200;
			armorDescLabel = new Label(vBoxRight, 0, 0, "Head Desc Label");
			armorDescLabel.autoSize = true;
			armorDescLabel.textField.width = 250;
			armorDescLabel.textField.wordWrap = true;
			weaponComboBox = new ComboBox(vBoxRight, 0, 0);
			weaponComboBox.width = 200;
			weaponNameLabel = new Label(vBoxRight, 0, 0, "Head Item Name");
			weaponComboBox.width = 200;
			weaponDescLabel = new Label(vBoxRight, 0, 0, "Head Desc Label");
			weaponDescLabel.autoSize = true;
			weaponDescLabel.textField.width = 250;
			weaponDescLabel.textField.wordWrap = true;
			
			headComboBox.addEventListener(Event.SELECT, onHeadSelected);
			bodyComboBox.addEventListener(Event.SELECT, onBodySelected);
			armorComboBox.addEventListener(Event.SELECT, onArmorSelected);
			weaponComboBox.addEventListener(Event.SELECT, onWeaponSelected);
			
			avatar = new Avatar();
			avatar.setBody(PlayerData.instance.body+".png");
			avatar.setHead(PlayerData.instance.head+".png");
			
			avatar.scaleX = 2.5;
			avatar.scaleY = 2.5;
			avatar.x = 150;
			avatar.y = 100;
			
			addChild(avatar);
			
			weaponHolder = new ItemViewer();
			weaponHolder.scaleX = 1.5;
			weaponHolder.scaleY = 1.5;
			
			weaponHolder.x = 100;
			weaponHolder.y = 300;
			
			addChild(weaponHolder);
			
			armorHolder = new ItemViewer();
			armorHolder.scaleX = 1.5;
			armorHolder.scaleY = 1.5;
			
			armorHolder.x = 250;
			armorHolder.y = 300;
			
			addChild(armorHolder);
			
			saveButton = new PushButton(hBox, 0, 0, "Save", onSaveButton);
			backButton = new PushButton(hBox, 0, 0, "Home", onBackButton);
			
		}
		
		override public function onShow():void{
			headValue = PlayerData.instance.head;
			bodyValue = PlayerData.instance.body;
			armorValue = PlayerData.instance.armor;
			weaponValue = PlayerData.instance.weapon;
			
			populateItems(ItemDataObject.HEAD, onHeadLoaded);
			populateItems(ItemDataObject.BODY, onBodyLoaded);
			populateItems(ItemDataObject.ARMOR, onArmorLoaded);
			populateItems(ItemDataObject.WEAPON, onWeaponLoaded);
		}
		
		private function enabled(val:Boolean):void{
			editNameText.enabled = val;
			headComboBox.enabled = val;
			bodyComboBox.enabled = val;
			weaponComboBox.enabled = val;
			armorComboBox.enabled = val;
			backButton.enabled = val;
			saveButton.enabled = val;
		}
		
		private function onSaveButton(evt:Event):void{
			enabled(false);
			saveToDatabase();
		}
		
		private function saveToDatabase():void{
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.name = editNameText.text;
			urlVariables.head = headValue;
			urlVariables.body = bodyValue;
			urlVariables.uid = PlayerData.instance.uid;
			urlVariables.armor = armorValue;
			urlVariables.weapon = weaponValue;
			
			var urlRequest:URLRequest = new URLRequest("saveProfile.php");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVariables;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onProfileSaved);
			urlLoader.load(urlRequest);
		}
		
		private function onProfileSaved(evt:Event):void{
			enabled(true);
		}
		
		private function onBackButton(evt:Event):void{
			ScreenManager.instance.goto(DangerItems.WELCOME);
		}
		
		private function onHeadSelected(evt:Event):void{
			setHeadDisplay(headComboBox.selectedItem as ItemDataObject);
		}
		
		private function onBodySelected(evt:Event):void{
			setBodyDisplay(bodyComboBox.selectedItem as ItemDataObject);
		}
		
		private function onArmorSelected(evt:Event):void{
			setArmorDisplay(armorComboBox.selectedItem as ItemDataObject);
		}
		
		private function onWeaponSelected(evt:Event):void{
			setWeaponDisplay(weaponComboBox.selectedItem as ItemDataObject);
		}
		
		private function setHeadDisplay(item:ItemDataObject):void{
			headNameLabel.text = item.name + "(" + item.price + ")";
			headDescLabel.text = item.description;
			avatar.setHead(item.id+".png");
			headValue = item.id;
		}
		
		private function setBodyDisplay(item:ItemDataObject):void{
			bodyNameLabel.text = item.name + "(" + item.price + ")";
			bodyDescLabel.text = item.description;
			avatar.setBody(item.id+".png");
			bodyValue = item.id;
		}
		
		private function setArmorDisplay(item:ItemDataObject):void{
			armorNameLabel.text = item.name + "(" + item.price + ")";
			armorDescLabel.text = item.description;
			armorHolder.setURL(item.id+".png");
			armorValue = item.id;
		}
		
		private function setWeaponDisplay(item:ItemDataObject):void{
			weaponNameLabel.text = item.name + "(" + item.price + ")";
			weaponDescLabel.text = item.description;
			weaponHolder.setURL(item.id+".png");
			weaponValue = item.id;
		}
		
		private function onHeadLoaded(evt:Event):void{
			var obj:Array = JSON.decode(evt.target.data);
			populateCombobox(obj, headComboBox);
			setHeadDisplay(headComboBox.selectedItem as ItemDataObject);
		}
		
		private function onBodyLoaded(evt:Event):void{
			var obj:Array = JSON.decode(evt.target.data);
			populateCombobox(obj, bodyComboBox);
			setBodyDisplay(bodyComboBox.selectedItem as ItemDataObject);
		}
		
		private function onArmorLoaded(evt:Event):void{
			var obj:Array = JSON.decode(evt.target.data);
			populateCombobox(obj, armorComboBox);
			setArmorDisplay(armorComboBox.selectedItem as ItemDataObject);
		}
		
		private function onWeaponLoaded(evt:Event):void{
			var obj:Array = JSON.decode(evt.target.data);
			populateCombobox(obj, weaponComboBox);
			setWeaponDisplay(weaponComboBox.selectedItem as ItemDataObject);
		}
		
		private function populateCombobox(obj:Array, combobox:ComboBox):void{
			Logger.print(this, "Size: " + obj.length);
			combobox.removeAll();
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
					combobox.addItem(itemData);
				}
				combobox.selectedIndex = 0;
			}
			combobox.enabled = true;
		}
		
		private function populateItems(type:int, handler:Function):void{
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.uid = PlayerData.instance.uid;
			urlVariables.type = type;
			
			var urlRequest:URLRequest = new URLRequest("getInventoryItems.php");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVariables;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, handler);
			urlLoader.load(urlRequest);
		}
		
		override public function onHide():void{
			
		}
	}
}