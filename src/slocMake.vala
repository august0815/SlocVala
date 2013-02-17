/*
Copyright (c) 2013 Mario Marcec <mario.marce42@googlmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/
using GLib;
using Gee;
using SLOCC;
/**
 * TODO: Add documentation here.
 */
public class SlocMake : SLOC
{
public ArrayList<string> filename = new ArrayList<string>() ;
public ArrayList<int> slocsum = new ArrayList<int>();
public ArrayList<string> typ = new ArrayList<string>();
public int gesamtsloc{get;set;}
public int lloc{get;set;}
public int leer{get;set;}
public int all{get;set;}

	public SlocMake(){
	gesamtsloc=0;
	leer=0;
	lloc=0;
	all=0;
	}
	public override void neusloc() {
         filename.clear();
		 slocsum .clear();
		 typ.clear();
		 lloc=0;
		 leer=0;
		 all=0;
		 gesamtsloc=0;
    }
	public override void addsloc(string filetocount,string dir){
	int alt=all-leer-lloc;
	int neu=all-leer+count(filetocount,dir);
	int sloc=neu-alt;
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
	
	
	protected override int count(string filetocount,string dir){
	 /** 
	 *  simples Zählen
	 * nur Kommentare in der Form = "//" und "/*" werden ignoriert
	 */
	string filename = filetocount;
	string d=dir;
	string content;
	int ssloc=0;
	string help;
	string workstring="";	
	 //  Zähle LeerZeilen
      var file = File.new_for_path (d+filename);  
      var ins = new DataInputStream (file.read (null));
      string line;
      // Read lines until end of file (null) is reached
      while ((line = ins.read_line (null, null)) != null) {
			  if (line==""){
			     leer++;
			   }
			   all ++;
	}
	
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
     	if(c=='#') {
			  //s = s.next_char (); 
			  //c = s.get_char ();
			  workstring += "\n";
			  		while (!(c=='\n')){
				  	  s = s.next_char (); 
				  	  c = s.get_char ();
				  	}
			  	
		  	}
		  	else  { 
			//Ignoriert einzelne '}' , ')' und TAB am anfang der Zeile
			if (c!='	'){
		  	  help = c.to_string();
		  	  
		  	  workstring += help;
				}
		    }
	    }
	    	 
      string[]  in_stream = workstring.split("\n");
      /** @TODO: 
       * 
       */
      int lsloc=0;
      ssloc =in_stream.length-1;
      for (int ii=0; ii< ssloc; ii++)
		{
		  if (!(in_stream[ii]=="")){lsloc ++;}
		}
		lloc +=lsloc;
		return lsloc;
	}
	public override string getText(){
		string text = "";
		int filecount=filename.size;
		int rem=all-leer-lloc;
	for (int i=0;i<filecount;i ++){
			text += "LIST MAKE "+filename[i]+" =>  TYP  : "+typ[i]+ "  Sloc  = "+slocsum[i].to_string()+"\n";
			}
		text +="\nAnteil LogicalLine = "+lloc.to_string();
		text +="\nAnteil KommentarLine = "+rem.to_string();
		text +="\nAnteil LEERLine = "+leer.to_string();
		text +="\nAnteil AlleLine = "+all.to_string();
		text +="\n\n------------------------------------------------------------------\n";
		text += claculate(lloc);
		return text;
	}

	 protected override string claculate(int summe){
	/** This is based on get_sloc.perl of SLOCCount
	*  http://www.dwheeler.com. by David A. Wheeler 
	* Default values for the effort estimation model; the model is
    * effort = ($effort_factor * KiloSLOC) ** $effort_exponent.
    * The following numbers are for basic COCOMO: 
    * If ther were any errory please reoprt.
    */
    double effort_factor =  2.40;
    double effort_exponent =  1.05;
    string effort_estimation_message = "Basic COCOMO model,";

    double schedule_factor =  2.5;
    double schedule_exponent =  0.38;
    string schedule_estimation_message = "Basic COCOMO model,";
    /** Average Salary / year.
    * Source :http://www1.salary.com/Programmer-I-Salary.html
    * 
	*The median expected salary for a typical Programmer II  in the United States is $67,219.
	*/
    double person_cost = 67219;

    /** Overhead; the person cost is multiplied by this value to determine
    * true annual costs.
    */
    double overhead = 2.4;
    string text="";
    text +="\n\n SLOC of Project  => " + summe.to_string()+"\n";
            /**
             *  Given the SLOC, reply an estimate of the number of person-months
			 * needed to develop it traditionally.
             * public double pow (double x, double y) is x^y
             */ 
            double tmp =summe/1000.0;
            double grand_total_effort=(effort_factor*(Math.pow(tmp,effort_exponent)));
			double grand_total_effort1=grand_total_effort/12;
			//text +="\nEstimated Development Effort in Person-Years (Person-Months)  =  "+"%10.2f".printf(grand_total_effort)+"("+"%10.2f".printf(grand_total_effort1)+")\n"; 
            //text +="(Basic COCOMO model, Person-Months = 2.4 * (KSLOC**1.05))\n";
            double schadule=(effort_factor*(Math.pow(grand_total_effort,schedule_exponent)));
            double schadule1=schadule/12;
            //text +="Schedule Estimate, Years (Months) =  "+"%10.2f".printf(schadule)+"("+"%10.2f".printf(schadule1)+")\n";
            //text +="(Basic COCOMO model, Months = 2.5 * (person-months**0.38))";
            /**
             *  Given the person-months, reply an estimate of the number of months
             * needed to develop it traditionally.
             */
            double ava=grand_total_effort1/schadule1;
			//text += "\nEstimated Average Number of Developers (Effort/Schedule)  = " +"%10.2f".printf(schadule)+"\n";
			double value1 = (grand_total_effort / 12.0) * person_cost * overhead;
            text +="\nTotal Estimated Cost to Develop ="+"%10.2f".printf(value1);
            //text +="\n (average salary = $"+person_cost.to_string()+"/year, overhead ="+"%2.2f".printf(overhead);
            
            int filecount=filename.size;
			text +="\n Total Number of Files = "+filecount.to_string()+"\n";
             /** @TODO Ausgabe über Interface Report 
             */
              
         return text  ;
		}
}
