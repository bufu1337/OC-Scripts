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
	if ( search instanceof Array ){
		for (var j = 0; j < search.length; j++){
			if ( this.split(search[j].toString()).length > 1 ){
				return true;
			}
		}
	}
	else{
		return this.split(search.toString()).length > 1
	}
	return false
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
    if(this.length == 0){ return false }
    for (var i = 0; i < this.length; i++){
		if ( !this[i].toString().equals("true") ){
			return false;
		}
	}
	return true;
};
Array.prototype.isOneBoolTrue = function(){
    for (var i = 0; i < this.length; i++){
		if ( this[i].toString().equals("true") ){
			return true;
		}
	}
	return false;
};
Array.prototype.contains = function(search){
    for (var i = 0; i < this.length; i++){
		if ( this[i].toString().equals(search) ){
			return true;
		}
	}
	return false;
};
Array.prototype.containsEx = function(search){
    for (var i = 0; i < this.length; i++){
		if ( this[i].toString().contains(search) ){
			return true;
		}
	}
	return false;
};
Number.prototype.equals = function(num){
	return this == num;
};
Boolean.prototype.equals = function(bool){
	return this == bool;
};
Object.defineProperty(Object.prototype, "Copy", {
    enumerable: false,
    writable: true,
    value: function(exceptions, includes) {
    	//console.log("arguments length: " + arguments.length);
		var returning;
		if ( this instanceof Array == false && this instanceof Object){
			returning = {};
		}
		else if ( this instanceof Array){
			returning = new Array();
		}
		if ( !exceptions ) {
			exceptions = ""
		}
		for (var i = 0; i < Object.keys(this).length; i++){
			if ( !Object.keys(this)[i].equals(exceptions) || exceptions.equals("") ) {
				if ( this[Object.keys(this)[i]] instanceof Object){
					returning[Object.keys(this)[i]] = this[Object.keys(this)[i]].Copy();
				}
				else{
					returning[Object.keys(this)[i]] = this[Object.keys(this)[i]];
				}
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
            if ( this instanceof Array == false && this instanceof Object && arguments[0] instanceof Array == false && arguments[0] instanceof Object ){
                var temp = [true]
				var t=this
				var b = arguments[0]
                $.each(Object.keys(t), function (i, v) {
                    temp.push(t[v].equals(b[v]))
                });
                return temp.isBoolListTrue()
            }
            else if ( this instanceof Array && arguments[0] instanceof Array){
                return JSON.stringify(this.sort()).equals(JSON.stringify(arguments[0].sort()));
            }
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