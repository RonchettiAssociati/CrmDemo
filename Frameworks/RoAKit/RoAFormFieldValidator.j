/*
 * RoAFormFieldValidator.j
 * WktTest57
 *
 * Created by Bruno Ronchetti on February 14, 2010.
 * Copyright 2010, Ronchetti & Associati All rights reserved.
 */

@import <Foundation/CPObject.j>


@import <RoAKit/ThirdParty/BRoDatejs/date.js>
@import <RoAKit/ThirdParty/BRoDatejs/it-IT.js>
@import <RoAKit/ThirdParty/BRoDatejs/core.js>
@import <RoAKit/ThirdParty/BRoDatejs/extras.js>
@import <RoAKit/ThirdParty/BRoDatejs/parser.js>
@import <RoAKit/ThirdParty/BRoDatejs/sugarpak.js>
@import <RoAKit/ThirdParty/BRoDatejs/time.js>

// VALIDATION FUNCTIONS
//
		
function isRequired(formField) {
	//alert("nella function"+ formField);
	var isValid = true;
	if (formField == "" || formField == " ") isValid=false;
	//alert("required risulta "+isValid);
	return isValid;
}

function isOptional(formField) {
	//always true;
	return true;
}

function isString(formField) {
	return isPattern(formField,"[\&a-zA-Z0-9 ,'-àèìòù]+");	// Aggiunge & commerciale e caratteri accentati
}

function isAddress(formField) {
	return isPattern(formField,"[A,CH,D,F,I]-[0-9]{4,5}[a-z,A-Z,0-9 .-]+$");
}

function isNumeric(formField) {
	return isPattern(formField,"\\d+");
}

function isAmount(formField) {
	//return isPattern(formField,"\\d+\,{0,1}\\d{0,2}");
	return isPattern(formField,"[ 0-9]+\,{0,1}\\d{0,2}");
}

function isEmail(formField) {
	return isPattern(formField,"[a-zA-Z0-9_.]+@[a-z,A-Z,0-9]+[.]{1}[a-z]{2,3}$")
}

function isDate(formField) {
	//alert("in validation validating date "+formField);
	var isValid = (Date.parse(formField) != null);
	return isValid;
}

function isTelephone(formField) {
	return isPattern(formField,"[0-9 +\-]+")
}

function emptyFunction() {
	return true;
}

function isPattern(formField,pattern) {
	if (formField != "")
	{
		var regExp = new RegExp("^"+pattern+"$","");
		var isValid = regExp.test(formField);
		//alert ("il risultato del reg exp è "+isValid);
		return isValid;
	}
}


var validationMessages = new Object();
validationMessages["required"] = @"requiredErrorMessage";
validationMessages["string"] = @"stringErrorMessage";
validationMessages["numeric"] = @"numericErrorMessage";
validationMessages["amount"] = @"amountErrorMessage";
validationMessages["address"] = @"addressErrorMessage";
validationMessages["email"] = @"emailErrorMessage";
validationMessages["date"] = @"dateErrorMessage";
validationMessages["telephone"] = @"telephoneErrorMessage";

var validationFunctions = new Object();
validationFunctions["required"] = isRequired;
validationFunctions["optional"] = isOptional;
validationFunctions["string"] = isString;
validationFunctions["pattern"] = isPattern;
validationFunctions["address"] = isAddress;
validationFunctions["numeric"] = isNumeric;
validationFunctions["amount"] = isAmount;
validationFunctions["email"] = isEmail; 
validationFunctions["date"] = isDate;
validationFunctions["telephone"] = isTelephone;


	
@implementation RoAFormFieldValidator : CPObject
{
}

-(CPObject)validate:(CPstring)aString forDescriptor:(CPArray)aValidationDescriptor
{
	self = [super init];
	if (self)
	{
		var theString = aString;
		var theValidationDescriptor = [CPArray arrayWithArray:aValidationDescriptor];

		var errorMessage = @"no error";
		
		// skip the first element, which only specifies when the validation should be done
		// (i.e. should be "immediate" or "deferred"
		//
		
		for (var i=1; i<[theValidationDescriptor count]; i++)
		{
			var requestedValidation = theValidationDescriptor[i];
			var isFieldValid = validationFunctions[requestedValidation](theString);
						
			if (isFieldValid == false)
			{
				errorMessage = validationMessages[requestedValidation];
				break;
			}
		}
	
	return RoALocalized(errorMessage);
	}
}

@end



