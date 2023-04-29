part of 'bottom_nav_bloc.dart';



abstract class BottomNavEvent {
  const BottomNavEvent();
}// this is the event that's triggered when the user
// wants to change pages
class NavigateTo extends BottomNavEvent {
  final int page;
  const NavigateTo(this.page);


}

class UpdateAmicaliste extends BottomNavEvent{
  final String amicaliste;
  const UpdateAmicaliste(this.amicaliste);
}


class UpdateGroupValue extends BottomNavEvent{
  final String value;
  final  kind;
  const UpdateGroupValue(this.value, this.kind);
}

class UpdateCommand extends BottomNavEvent{
  final String myCommande;
  const UpdateCommand(this.myCommande);
}

class DeleteItemFromItemList extends BottomNavEvent{
  final String item;
  const DeleteItemFromItemList(this.item);
}
class InitiateJson extends BottomNavEvent{
  const InitiateJson();
}
class AddItemInStock extends BottomNavEvent{
  final String key;
  final List<double> item;
  const AddItemInStock(this.key, this.item);
}

class addOrIncrementValue extends BottomNavEvent{
  final String item;
  const addOrIncrementValue(this.item);
}

class ClearCurrentCommande extends BottomNavEvent{
  const ClearCurrentCommande();
}

class WriteFile extends BottomNavEvent{
  const WriteFile();
}

class UpdatedThirdValue extends BottomNavEvent{
  const UpdatedThirdValue();
}
class UpdateSelectKey extends BottomNavEvent{
  final String item;
  const UpdateSelectKey(this.item);
}

class SaveCurrentCommande extends BottomNavEvent{
  const SaveCurrentCommande();
}

class IncreaseItem extends BottomNavEvent{
  final String item;
  const IncreaseItem(this.item);
}

class DecreaseItem extends BottomNavEvent{
  final String item;
  const DecreaseItem(this.item);
}
class UpdateNewStockValue extends BottomNavEvent{
  final double item;
  const UpdateNewStockValue(this.item);
}