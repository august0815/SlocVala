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
