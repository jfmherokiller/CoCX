package classes {
import classes.internals.Utils;

import flash.utils.Dictionary;

/**
 * A template to dynamically create parametrized items.
 *
 * Templated items have id in format "template_id;params_json"
 * Example: 'Dye;{"color":"black"}'
 */
public class ItemTemplate extends Utils {
	private static const TEMPLATES:Dictionary = new Dictionary();
	public static function lookupTemplate(templateId:String):ItemTemplate {
		return TEMPLATES[templateId];
	}
	
	/**
	 * Unique id
	 */
	public var templateId:String;
	/**
	 * Display name (mostly for debugging)
	 */
	public var name:String;
	
	public function ItemTemplate(templateId:String, name:String) {
		this.templateId = templateId;
		this.name       = name;
		if (templateId in TEMPLATES) {
			CoC_Settings.error("Duplicate ItemTemplate "+templateId);
		}
		TEMPLATES[templateId] = this;
	}
	
	public function createItem(parameters:Object): ItemType {
		CoC_Settings.errorAMC("ItemTemplate","createItem");
		return null;
	}
	
	public static function createTemplatedItem(templateId:String, params:*): ItemType {
		var template:ItemTemplate = lookupTemplate(templateId);
		if (!template) {
			CoC_Settings.error("Unknown item template "+templateId);
			return null;
		}
		if (params is String) {
			try {
				params = JSON.parse(params);
			} catch (e:Error) {
				CoC_Settings.error("Invalid template param string: "+params);
				return null;
			}
		}
		return template.createItem(params);
	}
}
}
