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
using Gtk;
using Gee;

	class ProjektWindow : Gtk.Window
	{
	
	public Gtk.Box vbox;	
	/**
	 * Creates a  window.
	 */
    private TextView text_view;
	/**
	 * Use to switch welcomscreen
	 */
	private bool welcom=true;
	/**
	 * List of file extentions 
	 */
	public ArrayList<string> list;
	/**
	 * List of vala source files
	 */
	public SlocV projekt_vala;
	/**
	 * List of cmake wscript or makefiles 
	 */
	public  SlocMake projekt_make;
	/**
	 * Count Makefiles?
	 */
	private bool make=false;
	private bool cmake=false;
	private bool wscript=false;
	/**
	 * Output formats
	 */
	private bool simple=false;
	private bool html=false;
	private bool pdf=false;
	private bool xml=true;
	/**
	 * Remember the last file
	 */
	private string last_filename="";
		
		Granite.Widgets.Welcome welcome;
		
		// Toolbar elements
		Gtk.Toolbar toolbar = new Gtk.Toolbar();
		Gtk.Menu menu;
		Granite.Widgets.AppMenu appMenu;

		
		// Preferences

		/**
		 * Creates a  window.
		 */
		public ProjektWindow (string? path = "", Granite.Application app) {
				projekt_vala=new SlocV();
				projekt_make = new SlocMake();
				list = new ArrayList<string> ();
				list.add ("vala");
				//list.add ("wscript");
			set_default_size (800, 600);
			menu = new Gtk.Menu();
			welcome = new Granite.Widgets.Welcome("Count sorce code of lines in VALA-codefiles\n  Start: select an directory .", "Open ...");
			
			// Menu
			menu.show_all();
			var make_menuitem = new Gtk.CheckMenuItem.with_label("make");
			var cmake_menuitem = new Gtk.CheckMenuItem.with_label("cmake");			
			var wscript_menuitem = new Gtk.CheckMenuItem.with_label("wscript");
			var simple_menuitem = new Gtk.CheckMenuItem.with_label("Simple");
			simple_menuitem.set_active(simple);
			var html_menuitem = new Gtk.CheckMenuItem.with_label("html");
			var pdf_menuitem = new Gtk.CheckMenuItem.with_label("pdf");			
			var xml_menuitem = new Gtk.CheckMenuItem.with_label("xml");
			
			menu.append(make_menuitem);
			menu.append(cmake_menuitem);
			menu.append(wscript_menuitem);
			menu.append(new Gtk.SeparatorMenuItem());
			menu.append(simple_menuitem);
			menu.append(html_menuitem);
			menu.append(pdf_menuitem);
			menu.append(xml_menuitem);			
			// AppMenu

			appMenu = app.create_appmenu(menu);
			var appMenu_item = new Gtk.ToolItem();
			appMenu_item.add(appMenu);

			// Menu item connections
			make_menuitem.activate.connect(on_make);
			cmake_menuitem.activate.connect(on_cmake);
			wscript_menuitem.activate.connect(on_wscript);
			simple_menuitem.activate.connect(on_simple);
			html_menuitem.activate.connect(on_html);
			pdf_menuitem.activate.connect(on_pdf);
			xml_menuitem.activate.connect(on_xml);
			
				
			// Toolbar
			toolbar.get_style_context().add_class ("primary-toolbar");
			ToolButton menue_open =new ToolButton(new Image.from_stock(Stock.OPEN,IconSize.BUTTON),"");
			ToolButton print_open =new ToolButton(new Image.from_stock(Stock.PRINT,IconSize.BUTTON),"");
			ToolButton refresh_open =new ToolButton(new Image.from_stock(Stock.REFRESH,IconSize.BUTTON),"");
			toolbar.insert(appMenu_item, -1);
			toolbar.insert(menue_open, -1);
			toolbar.insert(refresh_open, -1);
			toolbar.insert(print_open, -1);
			// Text
		    this.text_view = new TextView ();
			this.text_view.editable = false;
			this.text_view.cursor_visible = false;

			// Basic UI
			vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			add (vbox);
			vbox.pack_start (toolbar, false, false);
			vbox.pack_start (welcome, true, true);
			vbox.show_all();
			toolbar.show_all();

			welcome.append(Gtk.Stock.OPEN, "Open ", "Open ....");
			welcome.set_sensitive(true); 
			welcome.show_all();
			// Connections
			welcome.activated.connect(on_welcome_activated);
			menue_open.clicked.connect (on_opendir_clicked);
			refresh_open.clicked.connect (on_refresh_clicked);
			destroy.connect(close);
		}

		/**
		 * Called when a button of the welcome panel activated.
		 */
		private void on_welcome_activated(int index) {
			if (index == 0)
			{ on_opendir_clicked(); }
		}
		
		private void on_opendir_clicked () {
        var file_chooser = new FileChooserDialog ("Sloc DIR", this,
                                      FileChooserAction.SELECT_FOLDER,
                                      Stock.CANCEL, ResponseType.CANCEL,
                                      Stock.OPEN, ResponseType.ACCEPT);
        if (file_chooser.run () == ResponseType.ACCEPT) {
            open_dir (file_chooser.get_filename ());
        }
        file_chooser.destroy ();
		}
		/**
		*  Opendir
		*/
		private void open_dir (string filename) {
		
		File file = File.new_for_path(filename);
			last_filename=filename;
			list_children(file, new Cancellable (),filename+"/");
			if (welcom){
			welcom=false;
			vbox.remove(welcome);
			var scroll = new ScrolledWindow (null, null);
			scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
			scroll.add (this.text_view);
			vbox.pack_start (scroll,true,true);
			scroll.show_all();}
			report();
		}
		
	private void on_refresh_clicked () {
		if (last_filename!=""){
			File file = File.new_for_path(last_filename);

			list_children(file, new Cancellable (),last_filename+"/");
			report();
			}
		}
	private void list_children (File file, Cancellable? cancellable = null,string filename ) throws Error {
		FileEnumerator enumerator = file.enumerate_children ("standard::*",FileQueryInfoFlags.NOFOLLOW_SYMLINKS,cancellable);
		int gesamtsloc=0;
        
		FileInfo info = null;
		while (cancellable.is_cancelled () == false && ((info = enumerator.next_file (cancellable)) != null)) {
			if ((info.get_file_type () == FileType.DIRECTORY)&&(!(info.get_is_hidden ()))) {
					//ignoriere 'build' und '_build_'
					if ( (!(info.get_name()=="build"))&&(!(info.get_name()=="_build_"))&&(!(info.get_name()=="test"))) {
						File subdir = file.resolve_relative_path (info.get_name ());
						string filenam=filename+info.get_name()+"/";
						list_children (subdir,  cancellable,filenam); 
				}
			} else {
				if(!(info.get_is_hidden ())){
					foreach (string i in list) {
						//an Endung erkennen
							string[] end=info.get_name().split(".");
						if (end[1]==i){
							projekt_vala.addsloc(info.get_name (),filename);
							gesamtsloc=projekt_vala.gesamtsloc;
								}
						if (((make)||(cmake)||(wscript))&&(i==info.get_name())){
							projekt_make.addsloc(info.get_name (),filename);
							gesamtsloc=projekt_make.gesamtsloc;
								}
							}
						}
				}
			}
			
	if (cancellable.is_cancelled ()) {
		throw new IOError.CANCELLED ("Operation was cancelled");
	}
}

	private void on_make(){
		if (make){
		list.remove ("Makefile");
		make=false;}
		else{
			list.add ("Makefile");
			make=true;}
		}
	private void on_cmake(){
		if (cmake){
		list.remove ("CMakeLists.txt");
		cmake=false;}
		else{
			list.add ("CMakeLists.txt");
			cmake=true;}
		
		}
	private void on_wscript(){
		if (wscript){
		list.remove ("wscript");
		wscript=false;}
		else{
			list.add ("wscript");
			wscript=true;}
		}
	private void on_simple(){
		if (simple){
		//list.remove ("wscript");
		simple=false;}
		else{
			//list.add ("wscript");
			simple=true;}
		}
	private void on_html(){
		}
	private void on_pdf(){
		}
	private void on_xml(){
		}
	
	public void report(){
			string text="";
			simpleReport newreport=	new simpleReport();
			bool makereport=false;
			if ((make)||(cmake)||(wscript)){
				makereport=true;
				}
			text +=newreport.getText(projekt_vala,projekt_make,makereport);
			print ("********* Generated by https://github.com/august0815/SlocVala**********\n\n");
			print (text);
			this.text_view.buffer.text =  text;
			if (simple) {
				newreport.write(last_filename,text);
			}
			projekt_vala.neusloc();
			projekt_make.neusloc();
			
			}
		private void close() {
			hide();
			Gtk.main_quit();
		}		
	}

