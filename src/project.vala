/*
Copyright (c) 2013 Mairo Marcec <mario.marce42@googlmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/
using Gtk;
using Gee;

public class   Project : Object  {
		
	public Sloc projekt;
	public static string  project(string filename){
		/** 
		* @TODO TEILS NOT all files are for count !! seperate
		*/
		/** 
		* @TODO Übergabe der Verzeichnisses an sloc class  verbessern
		*/
		/** 
		* @TODO Rekursive verzeichnisse
		*/
		var list = new ArrayList<string> ();
		list.add (".vala");
		list.add (".c");
		list.add ("Makefile");
		list.add ("wscript");
			Sloc projekt=new Sloc();
			// It's a directory
            int gesamtsloc=0;
            var directory = File.new_for_path (filename);
            var enumerator = directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);
			int filecount =0 ;
            FileInfo file_info; 
            while ((file_info = enumerator.next_file ()) != null) {
            foreach (string i in list) {
              if (i in file_info.get_name())
              {
                 projekt.addsloc(file_info.get_name (),filename+"/");
                gesamtsloc=projekt.gesamtsloc;
                filecount++;
                  }
              }
             }
             projekt.addfilecount(filecount);
			 return projekt.getText();
           }
}
