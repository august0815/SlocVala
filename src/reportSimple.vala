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
public class simpleReport : REPORT
{
	//public SlocV projekt_vala;
	//public  SlocMake projekt_make;
	private int gesamt_lloc=0;
	private int gesamt_filecount=0;
	public simpleReport(){
		}
	public override string getText(SlocV projektV,SlocMake projektM,bool make){
		string text = "";
		
		if (make){
		int filecount=projektM.filename.size;
		int rem=projektM.all-projektM.leer-projektM.lloc;
		for (int i=0;i<filecount;i ++){
			text += "LIST MAKE "+projektM.filename[i]+" =>  TYP  : "+projektM.typ[i]+ "  Sloc  = "+projektM.slocsum[i].to_string()+ "\n";
			}
		text +="\nAnteil LogicalLine = "+projektM.lloc.to_string();
		text +="\nAnteil KommentarLine = "+rem.to_string();
		text +="\nAnteil LEERLine = "+projektM.leer.to_string();
		text +="\nAnteil AlleLine = "+projektM.all.to_string();
		text +="\n\n------------------------------------------------------------------\n";
		gesamt_lloc+=projektM.lloc;
		gesamt_filecount +=filecount;
			}
		
		int filecount=projektV.filename.size;
		int rem=projektV.all-projektV.leer-projektV.lloc;
	for (int i=0;i<filecount;i ++){
			text += "LIST FILENAME "+projektV.filename[i]+" =>  TYP  : "+projektV.typ[i]+ "  Sloc  = "+projektV.slocsum[i].to_string()+ "\n";
			}
		text +="\nAnteil LogicalLine = "+projektV.lloc.to_string();
		text +="\nAnteil KommentarLine = "+rem.to_string();
		text +="\nAnteil LEERLine = "+projektV.leer.to_string();
		text +="\nAnteil AlleLine = "+projektV.all.to_string();
		text +="\n\n------------------------------------------------------------------\n";
		gesamt_lloc+=projektV.lloc;
		gesamt_filecount+=filecount;
		text += claculate(gesamt_lloc,gesamt_filecount);
		return text;
	}

	
 protected override string claculate(int summe,int filecount){
	
	
	/** This is based on get_sloc.perl of SLOCCount
	*  http://www.dwheeler.com. by David A. Wheeler 
	* Default values for the effort estimation model; the model is
    * effort = ($effort_factor * KiloSLOC) ** $effort_exponent.
    * The following numbers are for basic COCOMO: 
    * If ther were any errory please reoprt.
    */
    double effort_factor =  2.40;
    double effort_exponent =  1.05;
    double schedule_factor =  2.5;
    double schedule_exponent =  0.38;
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
			text +="\nEstimated Development Effort in Person-Years (Person-Months)  =  "+"%10.2f".printf(grand_total_effort)+"("+"%10.2f".printf(grand_total_effort1)+")\n"; 
            text +="(Basic COCOMO model, Person-Months = 2.4 * (KSLOC**1.05))\n";
            double schadule=(schedule_factor*(Math.pow(grand_total_effort,schedule_exponent)));
            double schadule1=schadule/12;
            text +="Schedule Estimate, Years (Months) =  "+"%10.2f".printf(schadule)+"("+"%10.2f".printf(schadule1)+")\n";
            text +="(Basic COCOMO model, Months = 2.5 * (person-months**0.38))";
            /**
             *  Given the person-months, reply an estimate of the number of months
             * needed to develop it traditionally.
             */
            double ava=grand_total_effort1/schadule1;
			text += "\nEstimated Average Number of Developers (Effort/Schedule)  = " +"%10.2f".printf(ava)+"\n";
			double value1 = (grand_total_effort / 12.0) * person_cost * overhead;
            text +="\nTotal Estimated Cost to Develop ="+"%10.2f".printf(value1);
            text +="\n (average salary = $"+person_cost.to_string()+"/year, overhead ="+"%2.2f".printf(overhead);
            
           text +="\n Total Number of Files = "+filecount.to_string()+"\n";
			text +="\n\n------------------------------------------------------------------\n";
			text +="SlocVala, Copyright (c) 2013 Mario Marcec <mario.marce42@googlmail.com>\n";
			text +="SlocVala is Open Source Software/Free Software, licensed under the GNU GPL.\n";
			text +="SlocVala comes with ABSOLUTELY NO WARRANTY, and you are welcome to\n";
			text += "redistribute it under certain conditions as specified by the GNU GPL license;\n";
			text +="see the documentation for details.\n";
			text +="Please credit this data as \"generated using  Mario Marcec´s 'SlocVala'.\"\n";
             /** @TODO Ausgabe über Interface Report 
             */
              
         return text  ;
		}
}
