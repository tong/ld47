package ld47.node;

@:keep class NodeTree extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _SetMaterialValueParam = new armory.logicnode.SetMaterialValueParamNode(this);
		var _Keyboard = new armory.logicnode.MergedKeyboardNode(this);
		_Keyboard.property0 = "Started";
		_Keyboard.property1 = "space";
		var _Print = new armory.logicnode.PrintNode(this);
		_Print.addInput(_Keyboard, 0);
		_Print.addInput(new armory.logicnode.StringNode(this, "sss"), 0);
		_Print.addOutputs([new armory.logicnode.NullNode(this)]);
		_Keyboard.addOutputs([_SetMaterialValueParam, _Print]);
		_Keyboard.addOutputs([new armory.logicnode.BooleanNode(this, false)]);
		_SetMaterialValueParam.addInput(_Keyboard, 0);
		var _Material = new armory.logicnode.MaterialNode(this);
		_Material.property0 = "Dissolve";
		_Material.addOutputs([_SetMaterialValueParam]);
		_SetMaterialValueParam.addInput(_Material, 0);
		_SetMaterialValueParam.addInput(new armory.logicnode.StringNode(this, "Value"), 0);
		_SetMaterialValueParam.addInput(new armory.logicnode.FloatNode(this, 0.5), 0);
		_SetMaterialValueParam.addOutputs([new armory.logicnode.NullNode(this)]);
	}
}