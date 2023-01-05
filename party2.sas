proc sort data=party.invited
		  out=invited_sort;
	by Name;
run;

proc sort data=party.contacts
		  out=contacts_sort;
	by First_Name;
run;

Data ready2contact need_info not_invited;
	retain First_Name Last_Name Invite_Method Plus Address Phone Email;
	Keep First_Name Last_Name Invite_Method Plus Address Phone Email;
	length First_Name $ 9;
	merge invited_sort(in=inT1 rename=(Name=First_Name)) contacts_sort(in=inT2);
	by First_Name;
	
	if inT1 and inT2 then output ready2contact;
		else if inT1 and not inT2 then output need_info;
		else output not_invited;
run;

Title "Ready to contact";
proc print data=ready2contact;
run;