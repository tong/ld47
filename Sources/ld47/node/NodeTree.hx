package ld47.node;

@:keep class NodeTree extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		name = "NodeTree";
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _Print = new armory.logicnode.PrintNode(this);
		var _OnActionMarker = new armory.logicnode.OnActionMarkerNode(this);
		_OnActionMarker.addInput(new armory.logicnode.ObjectNode(this, "Sphere"), 0);
		_OnActionMarker.addInput(new armory.logicnode.StringNode(this, "F_30"), 0);
		_OnActionMarker.addOutputs([_Print]);
		_Print.addInput(_OnActionMarker, 0);
		_Print.addInput(new armory.logicnode.StringNode(this, "markker"), 0);
		_Print.addOutputs([new armory.logicnode.NullNode(this)]);
	}
}