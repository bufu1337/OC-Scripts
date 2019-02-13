String.prototype.format = function() {
    var formatted = this;
	var arraycounter = 0;
    for( var arg in arguments ) {
		if(Array.isArray(arguments[arg])){
			for( var arrayarg in arguments[arg] ) {
				formatted = formatted.replace("{" + arraycounter + "}", arguments[arg][arrayarg]);
				arraycounter++;
			}
		}
        else{
			var arglen = parseInt(arg) + parseInt(arraycounter);
        	formatted = formatted.replace("{" + arglen + "}", arguments[arg]);
        }
    }
    return formatted;
};
String.prototype.equals = function() {
	var returning = false;
	if ( arguments.length == 1 ){
		if ( arguments[0] instanceof Array){
			for (var i = 0; i < arguments[0].length; i++){
				if ( this.equals(arguments[0][i]) ){
					returning = true;
				}
			}
			return returning;
		}
		else if ( this.localeCompare(arguments[0]) == 0 ){
			return true;
		}
	}
	else{
		for (var i = 0; i < arguments.length; i++){
			if ( this.equals(arguments[i]) ){
				returning = true;
			}
		}
		return returning;
	}
    return false;
};
String.prototype.replaceAll = function(search, replacement) {
    return this.split(search).join(replacement);
};
String.prototype.isEmpty = function() {
	if ( this.equals("") && this.length == 0 ){return true;}
	else{return false;}
};
String.prototype.contains = function(search) {
	return this.split(search).length > 1
};
var sorting = {
	main: function (property) {
		var sortOrder = 1;
		if(property[0] === "-") {
			sortOrder = -1;
			property = property.substr(1);
		}
		return function (a,b) {
			var result = (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
			return result * sortOrder;
		}
	},										
	sort: function () {
		/*
		 * save the arguments object as it will be overwritten
		 * note that arguments object is an array-like object
		 * consisting of the names of the properties to sort by
		 */
		var props = arguments;
		return function (obj1, obj2) {
			var i = 0, result = 0, numberOfProperties = props.length;
			/* try getting a different result from 0 (equal)
			 * as long as we have extra properties to compare
			 */
			while(result === 0 && i < numberOfProperties) {
				result = sorting.main(props[i])(obj1, obj2);
				i++;
			}
			return result;
		}
	}
};
Object.defineProperty(Array.prototype, "sortBy", {
    enumerable: false,
    writable: true,
    value: function() {
        return this.sort(sorting.sort.apply(null, arguments));
    }
});
Array.prototype.isBoolListTrue = function(){
    for (var i = 0; i < this.length; i++){
		if ( !this[i].toString().equals("true") ){
			return false;
		}
	}
	return true;
};
Object.defineProperty(Object.prototype, "Copy", {
    enumerable: false,
    writable: true,
    value: function() {
    	//console.log("arguments length: " + arguments.length);
		var returning;
		if ( this instanceof Array == false && this instanceof Object){
			returning = {};
		}
		else if ( this instanceof Array){
			returning = new Array();
		}
		for (var i = 0; i < Object.keys(this).length; i++){
			if ( this[Object.keys(this)[i]] instanceof Object){
				returning[Object.keys(this)[i]] = this[Object.keys(this)[i]].Copy();
			}
			else{
				returning[Object.keys(this)[i]] = this[Object.keys(this)[i]];
			}
		}
        return returning;
    }
});
Object.defineProperty(Object.prototype, "combineStrings", {
    enumerable: false,
    writable: true,
    value: function() {
		var returning = "";
		var between = "";
		if ( arguments.length == 1 ){
			between = arguments[0];
		}
		if ( this instanceof Array == false && this instanceof Object){
			for (var i = 0; i < Object.keys(this).length; i++){
				returning += this[Object.keys(this)[i]] + between;
			}
		}
		else if ( this instanceof Array){
			for (var i = 0; i < this.length; i++){
				returning += this[i] + between;
			}
		}
		else{
			return "";
		}
		return returning.substring(0, returning.length - between.length);
	}
});
Object.defineProperty(Object.prototype, "equals", {
    enumerable: false,
    writable: true,
    value: function() {
		if ( arguments.length == 1 ){
			return JSON.stringify(this).equals(JSON.stringify(arguments[0]));
		}
		return false;
	}
});
Object.defineProperty(Object.prototype, "count", {
	enumerable: false,
	writable: true,
	value: function() {
    	return Object.keys(this).length
	}
});