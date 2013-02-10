using GLib;
using Gee;

/**
 * TODO: Add documentation here.
 */
public class Sloc : Object
{
public ArrayList<string> filename = new ArrayList<string>() ;
public ArrayList<int> slocsum = new ArrayList<int>();
public ArrayList<string> typ = new ArrayList<string>();
public int gesamtsloc{get;set;}
public int filecount{get;set;}

	public Sloc(){
	gesamtsloc=0;
	}
	public void addsloc(string filetocount,string dir){
	int sloc=count(filetocount,dir);
	if ("." in filetocount){
	typ.add(filetocount);
		}
		else {
	string[] type=filetocount.split(".");
	typ.add(type[1]);
		}
	filename.add(filetocount);
	slocsum.add(sloc);
	gesamtsloc +=sloc;
	}
	
	
	private int count(string filetocount,string dir){
	 /** 
	 *  simples Zählen
	 * nur Kommentare in der Form = "//" und "/" werden ignoriert
	 */
	string filename = filetocount;
	string d=dir;
	string content;
	int ssloc=0;
	string help;
	string workstring="";	
   	try { 
      filename=d+filename;
      FileUtils.get_contents (filename,out content);
   	} catch (FileError e) {
   		stderr.printf("%s\n",e.message );
  		return 1;
  	}
	/**
	* TODO: Typ abhängines Zählen !!  
    * 
    */
      for (weak string s = content; s.get_char ()!=0 ; s = s.next_char ()) {
      unichar c = s.get_char ();
    	if(c=='/') {
			  s = s.next_char (); 
			  c = s.get_char ();
			  if(c=='/') {
			  	workstring += "\n";
			  		while (!(c=='\n')){
				  	  s = s.next_char (); 
				  	  c = s.get_char ();
				  	}
			  	}	
			  if(c=='*') {
			  	while(true) {	
			  		s = s.next_char (); 
			  		c = s.get_char ();
			  		if(c=='*') {
				  		s = s.next_char (); 
				  		c = s.get_char ();
					  	if(c=='/') {
					  		break;
					    	}
				  	  }
			  	  }
			    }
		  	}
		  	else  { 
		  	  help = c.to_string();
		  	  
		  	  workstring += help;
		    }
	    }
	    	 
      string[]  in_stream = workstring.split("\n");
      /** @TODO: 
       * Prüfen ob I.O.
       */
      ssloc=in_stream.length;
      
     
	return ssloc;
	}
	public void addfilecount(int filecount){
		this.filecount=filecount;
		}
	public string getText(){
		string text = "";
	for (int i=0;i<filecount;i ++){
			text += "LIST FILENAME "+filename[i]+" =>  TYP  : "+typ[i]+ "  Sloc  = "+slocsum[i].to_string()+"\n";
			}
		text += claculate(gesamtsloc);
		return text;
	}

	 private string claculate(int summe){
	// This is based on get_sloc.perl of SLOCCount
	//  http://www.dwheeler.com. by David A. Wheeler 
	/* Default values for the effort estimation model; the model is
    * effort = ($effort_factor * KiloSLOC) ** $effort_exponent.
    * The following numbers are for basic COCOMO: */
    double effort_factor =  2.40;
    double effort_exponent =  1.05;
   // string effort_estimation_message = "Basic COCOMO model,";

    //double schedule_factor =  2.5;
   // double schedule_exponent =  0.38;
   // string schedule_estimation_message = "Basic COCOMO model,";
    /* Average Salary / year.
    * Source :http://www1.salary.com/Programmer-I-Salary.html
    * 
	*The median expected salary for a typical Programmer II  in the United States is $67,219.*/
    double person_cost = 67219;

    /* Overhead; the person cost is multiplied by this value to determine
    * true annual costs.*/
    double overhead = 2.4;
    string text="";
    text +="\n\n SLOC of Project  => " + summe.to_string()+"\n";
            // Given the SLOC, reply an estimate of the number of person-months
            // needed to develop it traditionally.
            //public double pow (double x, double y) 
            double tmp =summe/1000.0;
            double grand_total_effort=(effort_factor*(Math.pow(tmp,effort_exponent)));
			//double grand_total_effort1=grand_total_effort/12;
            //text +="\nEstimated Development Effort in Person-Years (Person-Months)  =  "+grand_total_effort.to_string()+"("+grand_total_effort1.to_string()+")\n"; 
            //text +="(Basic COCOMO model, Person-Months = 2.4 * (KSLOC**1.05))\n";
            //text +="Schedule Estimate, Years (Months) =  "+"\n";
            //text +="(Basic COCOMO model, Months = 2.5 * (person-months**0.38))";
            // Given the person-months, reply an estimate of the number of months
            // needed to develop it traditionally.
            
            //double estimate_schedule=(schedule_factor*(grand_total_effort*1)); //$schedule_exponent* ));
            double value1 = (grand_total_effort / 12.0) * person_cost * overhead;
            text +="\nTotal Estimated Cost to Develop ="+value1.to_string();
             /** @TODO Ausgabe verbessern , 
             */
              /** @TODO Ergebniss auf 2 Stellen runden
        	   */
         return text  ;
		}
}
