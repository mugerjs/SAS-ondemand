libname party xlsx "/home/u63010524/My SAS Files/party.xlsx";

Title "Party invitation contact information";

proc sql number;
select *
	from party.invited full join party.contacts
	on Name=First_Name;
quit;

*libname party close;

proc sort data=party.invited
		  out=party.invited_sort;
	by Name;
run;

proc sort data=party.contacts
		  out=party.contacts_sort;
	by First_Name;
run;

Data ds_merge;
	*length First_Name $ 9;
	merge party.invited_sort(rename=(Name=First_Name))
		  party.contacts_sort;
	by First_Name;
run;

Title "Data Step Full Merge Result";
proc print data=ds_merge;
run;

options fullstimer;

Title "SQL Join Results";

proc sql number;
select coalesce(Name, First_Name) as First_Name, Last_Name, Invite_Method, Address, Phone, Email
	from party.invited left join party.contacts
	on Name=First_Name
		order by First_Name;
quit;

options nofullstimer;

proc sort data=party.invited
		  out=party.invited_sort;
	by Name;
run;

proc sort data=party.contacts
		  out=party.contacts_sort;
	by First_Name;
run;

Data ds2_merge;
	retain First_Name Last_Name Invite_Method Address Phone Email;
	Keep First_Name Last_Name Invite_Method Address Phone Email;
	length First_Name $ 9;
	merge party.invited_sort(in=inT1 rename=(Name=First_Name))
		  party.contacts_sort(in=inT2);
	by First_Name;
	if inT1;
run;

Title "Data Step Merge Results";
proc print data=ds2_merge;
run;