//literally just a thing for scribble text typing, cringe, may change soon
if instance_number(oTextController) > 1
{
	instance_destroy();
	exit;
}

TextWriterList = [];
TextTypistList = [];
TextPosition = [];
TextSkipEnabled = [];