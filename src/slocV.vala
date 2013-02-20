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
 * Main Count in Source´s
 */
public class SlocV : SLOC
{
/**
 * Name of file
 */
public ArrayList<string> filename = new ArrayList<string>() ;
/**
 * the code lines 
 */
public ArrayList<int> slocsum = new ArrayList<int>();
/**
 * extention of file
 */
public ArrayList<string> typ = new ArrayList<string>();
/**
 * Path to file
 */
public ArrayList<string> dir = new ArrayList<string>();
/**
 *  sum of all files
 */
public int gesamtsloc{get;set;}
/**
 * sum of logical lines
 */
public int lloc{get;set;}
/**
 * Blank Lines
 */
public int leer{get;set;}
/**
 * raw sum of lines
 */
public int all{get;set;}

	public SlocV(){
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
	bool add=true;	
	int i=0;
	foreach (string s in filename){
		if ((s==filetocount)&&(dir==this.dir[i])){
			add=false;}
		i++;
		}
	if (add){			
		int alt=all-leer-lloc;
		int neu=all-leer+count(filetocount,dir);
		int sloc=neu-alt;
		if ("." in filetocount){
			string[] type=filetocount.split(".");
			typ.add(type[1]);
		}
		else {
			typ.add(filetocount);
			}
		filename.add(filetocount);
		slocsum.add(sloc);
		gesamtsloc +=sloc;
		this.dir.add(dir);
	  }
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
			//Ignoriert einzelne '}' , ')' und TAB am anfang der Zeile
			if ((c!='}')&&(c!=')')&&(c!='	')){
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

	
}
