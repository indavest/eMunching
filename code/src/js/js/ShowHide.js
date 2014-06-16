function showMe(id1,id2) {
		var obj1 = document.getElementById(id1);
		var obj2 = document.getElementById(id2);

	if (obj1.style.visibility=="hidden") { 
		obj1.style.visibility = "visible";
		obj2.style.visibility = "hidden";
	} else {
		obj1.style.visibility = "hidden";
		obj2.style.visibility = "visible";
	}
}