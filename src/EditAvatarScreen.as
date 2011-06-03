package
{
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
	
	import com.forgestory.model.Item;
	
	import com.forgestory.networking.GameNetworkConnection;
	
	import com.forgestory.rpg.Avatar;
	import com.forgestory.rpg.ItemViewer;
	import com.forgestory.rpg.PlayerData;
	
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
			
			editNameText = new InputText(vBoxRight, 0, 0, PlayerData.instance.player.username);
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
			avatar.setBody(PlayerData.instance.player.body+".png");
			avatar.setHead(PlayerData.instance.player.head+".png");
			
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
			headValue = PlayerData.instance.player.head;
			bodyValue = PlayerData.instance.player.body;
			armorValue = PlayerData.instance.player.armor;
			weaponValue = PlayerData.instance.player.weapon;
			
			populateItems(Item.HEAD, onHeadLoaded);
			populateItems(Item.BODY, onBodyLoaded);
			populateItems(Item.ARMOR, onArmorLoaded);
			populateItems(Item.WEAPON, onWeaponLoaded);
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
			with(PlayerData.instance.player){
				name = editNameText.text;
				head = headValue;
				body = bodyValue;
				armor = armorValue;
				weapon = weaponValue;
			}
			
			GameNetworkConnection.instance.savePlayer(onProfileSaved, PlayerData.instance.player);
		}
		
		private function onProfileSaved(evt:Event):void{
			enabled(true);
		}
		
		private function onBackButton(evt:Event):void{
			ScreenManager.instance.goto(DangerItems.WELCOME);
		}
		
		private function onHeadSelected(evt:Event):void{
			setHeadDisplay(headComboBox.selectedItem as Item);
		}
		
		private function onBodySelected(evt:Event):void{
			setBodyDisplay(bodyComboBox.selectedItem as Item);
		}
		
		private function onArmorSelected(evt:Event):void{
			setArmorDisplay(armorComboBox.selectedItem as Item);
		}
		
		private function onWeaponSelected(evt:Event):void{
			setWeaponDisplay(weaponComboBox.selectedItem as Item);
		}
		
		private function setHeadDisplay(item:Item):void{
			headNameLabel.text = item.name + "(" + item.price + ")";
			headDescLabel.text = item.description;
			avatar.setHead(item.id+".png");
			headValue = item.id;
		}
		
		private function setBodyDisplay(item:Item):void{
			bodyNameLabel.text = item.name + "(" + item.price + ")";
			bodyDescLabel.text = item.description;
			avatar.setBody(item.id+".png");
			bodyValue = item.id;
		}
		
		private function setArmorDisplay(item:Item):void{
			armorNameLabel.text = item.name + "(" + item.price + ")";
			armorDescLabel.text = item.description;
			armorHolder.setURL(item.id+".png");
			armorValue = item.id;
		}
		
		private function setWeaponDisplay(item:Item):void{
			weaponNameLabel.text = item.name + "(" + item.price + ")";
			weaponDescLabel.text = item.description;
			weaponHolder.setURL(item.id+".png");
			weaponValue = item.id;
		}
		
		private function onHeadLoaded(result:Object):void{
			populateCombobox(result, headComboBox);
			setHeadDisplay(headComboBox.selectedItem as Item);
		}
		
		private function onBodyLoaded(result:Object):void{
			populateCombobox(result, bodyComboBox);
			setBodyDisplay(bodyComboBox.selectedItem as Item);
		}
		
		private function onArmorLoaded(result:Object):void{
			populateCombobox(result, armorComboBox);
			setArmorDisplay(armorComboBox.selectedItem as Item);
		}
		
		private function onWeaponLoaded(result:Object):void{
			populateCombobox(result, weaponComboBox);
			setWeaponDisplay(weaponComboBox.selectedItem as Item);
		}
		
		private function populateCombobox(obj:Object, combobox:ComboBox):void{
			Logger.print(this, "Size: " + obj.length);
			combobox.removeAll();
			if(obj.length == 0){
				return;
			}else{
				for(var i:int = 0; i < obj.length; i++){
					combobox.addItem(obj[i]);
				}
				combobox.selectedIndex = 0;
			}
			combobox.enabled = true;
		}
		
		private function populateItems(type:int, handler:Function):void{
			var item:Item = new Item();
			item.type = type;
			GameNetworkConnection.instance.getMyInventory(handler, PlayerData.instance.player, item);
		}
		
		override public function onHide():void{
			
		}
	}
}